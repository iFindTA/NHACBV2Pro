//
//  NHDBEngine.m
//  NHFMDBPro
//
//  Created by hu jiaju on 16/2/17.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

/*
 *线程安全使用示例
 */

NSString * const NH_ADS_CACHE_NAMESPACE                =       @"com.youtu.acb";
NSString * const NH_ADS_CACHE_DIRECTORY                =       @"ads";

#import "NHDBEngine.h"
#import <FMDB/FMDB.h>
#import <SDWebImageManager.h>

static NSString *NHDBCipherKey = @"com.youtu.acb.ios";
static NSString *NHDBNAME = @"securityInfo.DB";
static NSString *NHSQLS   = @"NH_SQLS";

@interface NHDBEngine ()

@property (nonatomic, strong, nullable)FMDatabaseQueue *dbQueue;
@property (nonatomic, assign) BOOL adLoading;
@property (nonatomic, assign) int tmpDownloadPointer;

/**
 *  @brief 当前登录用户
 */
@property (nonatomic, strong) NHUsr *m_usr;
@property (nonatomic, strong) NHConfigure *m_config;

@end

static NHDBEngine *instance = nil;

@implementation NHDBEngine

+ (NHDBEngine *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self createFMDB];
    }
    return self;
}

- (NSString *)filePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *filePath = [[paths firstObject] stringByAppendingPathComponent:fileName];
    return filePath;
}

- (FMDatabaseQueue *)dbQueue {
    if (!_dbQueue) {
        NSString *dbpath = [self filePath:NHDBNAME];
        ///创建数据库及线程队列
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
    }
    return _dbQueue;
}

- (BOOL)createFMDB {
    
    __block BOOL ret = false;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db setKey:NHDBCipherKey];
        NSString *sqlFile = [[NSBundle mainBundle] pathForResource:NHSQLS ofType:@"txt"];
        if (!sqlFile) {
            return ;
        }
        NSString *sqls = [NSString stringWithContentsOfFile:sqlFile encoding:NSUTF8StringEncoding error:nil];
        NSArray *sqlArr = [sqls componentsSeparatedByString:@"|"];
        for (NSString *sql in sqlArr) {
            [db executeUpdate:sql];
        }
        NSString *filePath = NSHomeDirectory();
        NSLog(@"app sandbox path:%@",filePath);
        ret = true;
    }];
    
    return ret;
}

#pragma mark -- 初始化配置数据库 --

- (void)setup {
    //config ad
    [self setupForAD];
    //config usr
    [self setupForUsr];
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return formatter;
}

#pragma mark -- Commen Method --

- (BOOL)saveInfo:(id)info {
    __block BOOL ret = false;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *mSQL = @"INSERT OR REPLACE INTO t_plat_activity (infoid, info, time) VALUES(?, ?, ?)";
        NSNumber *infoid = [info objectForKey:@"infoid"];
        NSString *info_ = [info objectForKey:@"info"];
        NSDate *time = [info objectForKey:@"time"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:infoid];
        [params addObject:info_];
        [params addObject:time];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:mSQL withArgumentsInArray:params];
        NSLog(@"ret:%zd---插入数据",ret);
    }];
    
    return ret;
}

- (BOOL)deleteInfo:(id)info {
    
    __block BOOL ret = false;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSNumber *infoid = [info objectForKey:@"infoid"];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:@"DELETE FROM t_info_table WHERE infoid = ?",infoid,nil];
        NSLog(@"ret:%zd---删除数据",ret);
    }];
    
    return ret;
}

- (BOOL)updateInfo:(id)info {
    
    __block BOOL ret = false;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSNumber *infoid = [info objectForKey:@"infoid"];
        NSString *info_ = [info objectForKey:@"info"];
        NSDate *time = [info objectForKey:@"time"];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:@"UPDATE t_info_table SET info = ? AND time = ? WHERE infoid = ? ", info_, time, infoid, nil];
        NSLog(@"ret:%zd---更新数据",ret);
    }];
    
    return ret;
}

- (id)getInfo{
    
    __block NSMutableDictionary *tmpInfo = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///处理事情
        [db setKey:NHDBCipherKey];
        FMResultSet *retSets = [db executeQuery:@"SELECT * FROM t_info_table LIMIT 1",nil];
        while ([retSets next]) {
            NSString *infoid = [retSets stringForColumn:@"infoid"];
            NSString *info = [retSets stringForColumn:@"info"];
            NSString *time = [retSets stringForColumn:@"time"];
            NSDictionary *tmp = [NSDictionary dictionaryWithObjectsAndKeys:infoid,@"infoid",info,@"info",time,@"time", nil];
            tmpInfo = [NSMutableDictionary dictionaryWithDictionary:tmp];
        }
    }];
    
    return tmpInfo;
}
- (NSArray *)getInfos{
    
    __block NSMutableArray *tmpArray = [NSMutableArray array];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///处理事情
        [db setKey:NHDBCipherKey];
        FMResultSet *retSets = [db executeQuery:@"SELECT * FROM t_info_table",nil];
        while ([retSets next]) {
            NSString *infoid = [retSets stringForColumn:@"infoid"];
            NSString *info = [retSets stringForColumn:@"info"];
            NSString *time = [retSets stringForColumn:@"time"];
            NSDictionary *tmp = [NSDictionary dictionaryWithObjectsAndKeys:infoid,@"infoid",info,@"info",time,@"time", nil];
            [tmpArray addObject:tmp];
        }
    }];
    
    return [tmpArray copy];
}

#pragma mark -- AD abouts -- 

- (void)setupForAD {
    
    NSString *app_ver = [NSBundle pb_buildVersion];
    NSLog(@"app setting :%@",app_ver);
    
    NHConfigure *tmp_config = [self getConfigureForVersion:app_ver];
    if (tmp_config != nil) {
        NSLog(@"全局设置已存在:%@",app_ver);
        self.m_config = tmp_config;
    }else{
        NSLog(@"全局设置不存在，马上设置:%@",app_ver);
        NHConfigure *m_config = [[NHConfigure alloc] init];
        m_config.appv = app_ver;
        m_config.reviewed = @"0";
        m_config.guideFlashed = @"0";
        m_config.ext = @"";
        self.m_config = m_config;
        [self saveConfigureForVersion:app_ver];
    }
}

- (NHConfigure *)getConfigureForVersion:(NSString *)ver {
    __block NHConfigure *m_config = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///处理事情
        [db setKey:NHDBCipherKey];
        FMResultSet *retSets = [db executeQuery:@"SELECT * FROM t_app_setting WHERE appversion = ? LIMIT 1", ver, nil];
        while ([retSets next]) {
            m_config = [[NHConfigure alloc] init];
            m_config.appv = [retSets stringForColumn:@"appversion"];
            m_config.reviewed = [retSets stringForColumn:@"reviewed"];
            m_config.guideFlashed = [retSets stringForColumn:@"guideFlashed"];
            m_config.ext = [retSets stringForColumn:@"ext"];
        }
    }];
    return m_config;
}

- (BOOL)saveConfigureForVersion:(NSString *)ver {
    __block BOOL ret = false;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *mSQL = @"INSERT OR REPLACE INTO t_app_setting (appversion, reviewed, guideFlashed, ext) VALUES(?, ?, ?, ?)";
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:ver];
        [params addObject:@"0"];
        [params addObject:@"0"];
        [params addObject:@""];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:mSQL withArgumentsInArray:params];
        NSLog(@"ret:%zd---插入数据",ret);
    }];
    
    return ret;
}

- (NSDictionary *)shouldFlashAD {
    //TODO:to be remove!
    //return [NSDictionary new];
    
    __block NSMutableDictionary *tmpInfo = nil;
    
    if (!self.m_config) {
        NSLog(@"需要重置该版本的广告设置");
        [self setupForAD];
        return tmpInfo;
    }
    
    if (!self.m_config.reviewed.boolValue) {
        NSLog(@"审核期间不显示");
        return tmpInfo;
    }
    //如若可以显示 则继续
    NSDateFormatter *formatter = self.dateFormatter;
    NSString *now = [formatter stringFromDate:[NSDate date]];
    
    __block NSMutableArray *tmpArrs = [NSMutableArray array];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///处理事情
        [db setKey:NHDBCipherKey];
        FMResultSet *retSets = [db executeQuery:@"SELECT * FROM t_ads WHERE  download = 1 AND (datetime(start) < datetime(?) AND datetime(end) > datetime(?)) ORDER BY discount ASC",now, now, nil];
        while ([retSets next]) {
            NSString *adid = [retSets stringForColumn:@"adid"];
            NSString *imgurl = [retSets stringForColumn:@"img"];
            NSString *linkurl = [retSets stringForColumn:@"link"];
            NSString *type = [retSets stringForColumn:@"type"];
            NSString *distype = [retSets stringForColumn:@"distype"];
            NSString *discount = [retSets stringForColumn:@"discount"];
            NSDictionary *tmp = [NSDictionary dictionaryWithObjectsAndKeys:adid,@"adid",imgurl,@"img",linkurl,@"link",type,@"type",distype,@"distype",discount,@"discount", nil];
            [tmpArrs addObject:tmp];
        }
    }];
    
    if (!PBIsEmpty(tmpArrs)) {
        return nil;
    }
    //找到显示次数最少的那一个(多个的话则随机取)
    __block int tmpIdx = 0;__block NSMutableArray *tmpShows = [NSMutableArray array];
    [tmpArrs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        int tmp = [[obj pb_stringForKey:@"discount"] intValue];
        if (idx == 0) {
            tmpIdx = tmp;
            [tmpShows addObject:obj];
        }else{
            if (tmp == tmpIdx) {
                [tmpShows addObject:obj];
            }else if (tmp > tmpIdx){
                *stop = true;
            }
        }
    }];
    
    NSInteger tmpCount = [tmpShows count];int __Idx = 0;
    if (tmpCount > 1) {
        __Idx = arc4random()%tmpCount;
    }
    
    NSDictionary *__ad = [tmpShows objectAtIndex:__Idx];
    NSUInteger disCount = [[__ad objectForKey:@"discount"] unsignedIntegerValue];
    NSString *adid = [__ad objectForKey:@"adid"];
    [self increaseDiscount:disCount forAD:adid];
    return __ad;
}

//显示一次后 显示次数++
- (BOOL)increaseDiscount:(NSUInteger)count forAD:(NSString *)adid {
    __block BOOL ret = false;
    if (adid == nil) {
        return ret;
    }
    NSString *disCount = PBFormat(@"%zd",count++);
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:@"UPDATE t_ads SET discount = ? WHERE adid = ? ", disCount, adid, nil];
        NSLog(@"ret:%zd---更新数据",ret);
    }];
    
    return ret;
}

//网络上获取ad保存到本地
- (BOOL)saveAD:(NSDictionary *)ad {
    __block BOOL ret = false;
    
    if (ad == nil) {
        return ret;
    }
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *mSQL = @"INSERT INTO t_ads (adid, img, link, start, end, type, distype) VALUES(?, ?, ?, ?, ?, ?, ?)";
        NSString *adid = [ad objectForKey:@"adid"];
        NSString *imgurl = [ad objectForKey:@"img"];
        NSString *linkurl = [ad objectForKey:@"link"];
        NSString *start = [ad objectForKey:@"start"];
        NSString *end = [ad objectForKey:@"end"];
        NSString *type = [ad objectForKey:@"type"];
        NSString *distype = [ad objectForKey:@"distype"];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:adid];
        [params addObject:imgurl];
        [params addObject:linkurl];
        [params addObject:start];
        [params addObject:end];
        [params addObject:type];
        [params addObject:distype];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:mSQL withArgumentsInArray:params];
        NSLog(@"ret:%zd---插入数据",ret);
    }];
    
    return ret;
}

- (BOOL)clearExpiredADs {
    
    NSDateFormatter *formatter = self.dateFormatter;
    NSString *now = [formatter stringFromDate:[NSDate date]];
    
    __block BOOL ret = false;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:@"DELETE FROM t_ads WHERE datetime(end) < datetime(?)",now,nil];
        NSLog(@"ret:%zd---删除数据",ret);
    }];
    
    return ret;
}

//自动在后台、Wi-Fi环境下 下载广告图
- (NSDictionary *)getUnFinishedAD {
    
    //准备工作
    NSDateFormatter *formatter = self.dateFormatter;
    NSString *now = [formatter stringFromDate:[NSDate date]];
    
    __block NSMutableDictionary *tmpInfo = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///处理事情
        [db setKey:NHDBCipherKey];
        FMResultSet *retSets = [db executeQuery:@"SELECT * FROM t_ads WHERE  download = 0 AND (datetime(start) < datetime(?) AND datetime(end) > datetime(?)) ORDER BY datetime(start) DESC LIMIT 1",now, now, nil];
        while ([retSets next]) {
            NSString *adid = [retSets stringForColumn:@"adid"];
            NSString *imgurl = [retSets stringForColumn:@"img"];
            NSDictionary *tmp = [NSDictionary dictionaryWithObjectsAndKeys:adid,@"adid",imgurl,@"img", nil];
            tmpInfo = [NSMutableDictionary dictionaryWithDictionary:tmp];
        }
    }];
    
    return [tmpInfo copy];
}

- (BOOL)doneDownloadAD:(NSDictionary *)ad {
    __block BOOL ret = false;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSNumber *infoid = [ad objectForKey:@"adid"];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:@"UPDATE t_ads SET download = ? WHERE adid = ? ", @"1", infoid, nil];
        NSLog(@"ret:%zd---更新数据",ret);
    }];
    
    return ret;
}

- (void)stopAutoDownloadAD {
    self.adLoading = false;
    self.tmpDownloadPointer = 0;
}

- (void)autoDownloadADsViaWifi {
    if (!self.adLoading) {
        self.adLoading = true;
    }
    
    NSDictionary *tmp_ad = [self getUnFinishedAD];
    if (tmp_ad == nil || self.tmpDownloadPointer > 5) {
        [self stopAutoDownloadAD];
        NSLog(@"stop auto download ad's image!");
        return;
    }
    weakify(self)
    NSString *img_url_str = [tmp_ad pb_stringForKey:@"img"];
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:img_url_str] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        strongify(self)
        if (image != nil && finished) {
            SDImageCache *imgCache = [[SDImageCache alloc] initWithNamespace:NH_ADS_CACHE_NAMESPACE diskCacheDirectory:NH_ADS_CACHE_DIRECTORY];
            [imgCache storeImage:image forKey:img_url_str];
            [self doneDownloadAD:tmp_ad];
            [self autoDownloadADsViaWifi];
        }else{
            [self stopAutoDownloadAD];
        }
    }];
    self.tmpDownloadPointer ++;
}

#pragma mark -- authoried user abouts --

- (void)setupForUsr {
    NSUserDefaults *mDefaults = [NSUserDefaults standardUserDefaults];
    BOOL usrAutoLogout = [mDefaults boolForKey:NH_USR_AUTO_LOGOUT_KEY];
    if (!usrAutoLogout) {
        NSLog(@"当前用户未主动退出");
        //获取当前最后的登录用户
        self.m_usr = [self getLatestLogUsr];
    }
}

- (BOOL)logined {
    return self.m_usr != nil && self.m_usr.uid.length > 0 && self.m_usr.authorToken.length > 0;
}

- (BOOL)logout {
    // clear usr's author token by log out action
    NHUsr *tmpUsr = [self.m_usr copy];
    tmpUsr.authorToken = nil;
    _m_usr = nil;
    NSUserDefaults *mDefaults = [NSUserDefaults standardUserDefaults];
    [mDefaults setBool:true forKey:NH_USR_AUTO_LOGOUT_KEY];
    [mDefaults synchronize];
    [self saveLogUsr:tmpUsr];
    
    return true;
}

- (BOOL)authorize2Usr:(NHUsr *)usr syncronise:(BOOL)sync {
    if (_m_usr != nil) {
        _m_usr = nil;
    }
    self.m_usr = usr;
    //同步用户数据到数据库
    if (sync) {
        [self saveLogUsr:usr];
    }
    return true;
}

- (NHUsr *)authorizedUsr {
    return self.m_usr;
}

- (BOOL)saveLogUsr:(NHUsr *)usr {
    __block BOOL ret = false;
    
    if (usr == nil) {
        return ret;
    }
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *mSQL = @"INSERT OR REPLACE INTO t_usrs (uid, account, acctype, passwd, authorToken, gender, level, nick, avatar, signature, authorName, authorID, authorType, email, postal, state, province, city, logdate, overage, allIncome, numGolden, points, riskCapital, numBankCard, accWeiXin, accAlipay, ext) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        NSString *uid = usr.uid;
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:uid];
        [params addObject:PBAvailableString(usr.account)];
        [params addObject:PBAvailableString(usr.acctype)];
        [params addObject:PBAvailableString(usr.passwd)];
        [params addObject:PBAvailableString(usr.authorToken)];
        [params addObject:PBAvailableString(usr.gender)];
        [params addObject:usr.level?:@"0"];
        [params addObject:PBAvailableString(usr.nick)];
        [params addObject:PBAvailableString(usr.avatar)];
        [params addObject:PBAvailableString(usr.signature)];
        [params addObject:PBAvailableString(usr.authorName)];
        [params addObject:PBAvailableString(usr.authorID)];
        [params addObject:PBAvailableString(usr.authorType)];
        [params addObject:PBAvailableString(usr.email)];
        [params addObject:PBAvailableString(usr.postal)];
        [params addObject:PBAvailableString(usr.state)];
        [params addObject:PBAvailableString(usr.province)];
        [params addObject:PBAvailableString(usr.city)];
        [params addObject:PBAvailableString(usr.logdate)];
        [params addObject:PBAvailableString(usr.overage)];
        [params addObject:PBAvailableString(usr.allIncome)];
        [params addObject:PBAvailableString(usr.numGolden)];
        [params addObject:PBAvailableString(usr.points)];
        [params addObject:PBAvailableString(usr.riskCapital)];
        [params addObject:PBAvailableString(usr.numBankCard)];
        [params addObject:PBAvailableString(usr.accWeiXin)];
        [params addObject:PBAvailableString(usr.accAlipay)];
        [params addObject:PBAvailableString(usr.ext)];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:mSQL withArgumentsInArray:params];
        NSLog(@"ret:%zd---插入数据",ret);
    }];
    
    return ret;
}

- (NHUsr *)getLatestLogUsr {
    __block NHUsr *tmpUsr = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///处理事情
        [db setKey:NHDBCipherKey];
        FMResultSet *retSets = [db executeQuery:@"SELECT * FROM  t_usrs ORDER BY datetime(logdate) DESC LIMIT 1",nil];
        while ([retSets next]) {
            tmpUsr = [[NHUsr alloc] init];
            tmpUsr.uid = [retSets stringForColumn:@"uid"];
            tmpUsr.account = [retSets stringForColumn:@"account"];
            tmpUsr.acctype = [retSets stringForColumn:@"acctype"];
            tmpUsr.passwd = [retSets stringForColumn:@"passwd"];
            tmpUsr.authorToken = [retSets stringForColumn:@"authorToken"];
            tmpUsr.gender = [retSets stringForColumn:@"gender"];
            tmpUsr.level = [retSets stringForColumn:@"level"];
            tmpUsr.nick = [retSets stringForColumn:@"nick"];
            tmpUsr.avatar = [retSets stringForColumn:@"avatar"];
            tmpUsr.signature = [retSets stringForColumn:@"signature"];
            tmpUsr.authorName = [retSets stringForColumn:@"authorName"];
            tmpUsr.authorID = [retSets stringForColumn:@"authorID"];
            tmpUsr.authorType = [retSets stringForColumn:@"authorType"];
            tmpUsr.email = [retSets stringForColumn:@"email"];
            tmpUsr.postal = [retSets stringForColumn:@"postal"];
            tmpUsr.state = [retSets stringForColumn:@"state"];
            tmpUsr.province = [retSets stringForColumn:@"province"];
            tmpUsr.city = [retSets stringForColumn:@"city"];
            tmpUsr.logdate = [retSets stringForColumn:@"logdate"];
            tmpUsr.overage = [retSets stringForColumn:@"overage"];
            tmpUsr.allIncome = [retSets stringForColumn:@"allIncome"];
            tmpUsr.numGolden = [retSets stringForColumn:@"numGolden"];
            tmpUsr.points = [retSets stringForColumn:@"points"];
            tmpUsr.riskCapital = [retSets stringForColumn:@"riskCapital"];
            tmpUsr.numBankCard = [retSets stringForColumn:@"numBankCard"];
            tmpUsr.accWeiXin = [retSets stringForColumn:@"accWeiXin"];
            tmpUsr.accAlipay = [retSets stringForColumn:@"accAlipay"];
            tmpUsr.ext = [retSets stringForColumn:@"ext"];
        }
    }];
    
    return tmpUsr;
}

- (NHConfigure *)globalConfig {
    return self.m_config;
}

- (BOOL)syncronizedConfigReviewed:(BOOL)reviewed {
    NSString *app_ver = [NSBundle pb_buildVersion];
    
    __block BOOL ret = false;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *mSQL = @"INSERT OR REPLACE INTO t_app_setting (appversion, reviewed, ext) VALUES(?, ?, ?)";
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:app_ver];
        [params addObject:PBFormat(@"%d",reviewed?1:0)];
        [params addObject:@""];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:mSQL withArgumentsInArray:params];
        NSLog(@"ret:%zd---更新审核开关",ret);
    }];
    
    if (ret) {
        self.m_config.reviewed = PBFormat(@"%d",reviewed?1:0);
    }
    
    return ret;
}

- (BOOL)syncronizedConfigUsrGuideFlashed:(BOOL)flashed {
    NSString *app_ver = [NSBundle pb_buildVersion];
    
    __block BOOL ret = false;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *mSQL = @"INSERT OR REPLACE INTO t_app_setting (appversion, guideFlashed, ext) VALUES(?, ?, ?)";
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:app_ver];
        [params addObject:PBFormat(@"%d",flashed?1:0)];
        [params addObject:@""];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:mSQL withArgumentsInArray:params];
        NSLog(@"ret:%zd---更新用户引导开关",ret);
    }];
    
    if (ret) {
        self.m_config.guideFlashed = PBFormat(@"%d",flashed?1:0);
    }
    
    return ret;
}

#pragma mark -- daily signature

/**
 *  @brief 今日签到是否需要显示出来
 *
 *  @return yes is 需要
 */
- (BOOL)shouldFlashSignToday {
    NSDateFormatter *formatter = self.dateFormatter;
    NSString *now = [formatter stringFromDate:[NSDate date]];
    now = [[now componentsSeparatedByString:@" "] firstObject];
    
    __block BOOL ret = false;
    __block BOOL dayExist = false;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db setKey:NHDBCipherKey];
        FMResultSet *retSets = [db executeQuery:@"SELECT COUNT(day) AS allCounts FROM t_daily_sign WHERE day = ? LIMIT 1", now,nil];
        [retSets next];
        int counts = [retSets intForColumn:@"allCounts"];
        dayExist = counts > 0;
    }];
    __block BOOL shouldFlash = true;
    if (dayExist) {
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db setKey:NHDBCipherKey];
            FMResultSet *retSets = [db executeQuery:@"SELECT * FROM t_daily_sign WHERE day = ? LIMIT 1", now,nil];
            [retSets next];
            NSString *flash = [retSets stringForColumn:@"flash"];
            shouldFlash = !flash.boolValue;
        }];
    }else{
        //今日签到 标签还不存在
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *mSQL = @"INSERT OR REPLACE INTO t_daily_sign (day, sign, flash) VALUES(?, ?, ?)";
            NSMutableArray *params = [NSMutableArray array];
            [params addObject:now];
            [params addObject:@"0"];
            [params addObject:@"1"];
            ///执行SQL语句
            [db setKey:NHDBCipherKey];
            ret = [db executeUpdate:mSQL withArgumentsInArray:params];
            NSLog(@"ret:%zd---插入数据",ret);
        }];
    }
    
    return shouldFlash;
}

- (BOOL)wetherSigned {
    BOOL shouldFlash = [self shouldFlashSignToday];
    if (shouldFlash) {
        return false;
    }
    NSDateFormatter *formatter = self.dateFormatter;
    NSString *now = [formatter stringFromDate:[NSDate date]];
    now = [[now componentsSeparatedByString:@" "] firstObject];
    __block BOOL _signed = true;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db setKey:NHDBCipherKey];
        FMResultSet *retSets = [db executeQuery:@"SELECT * FROM t_daily_sign WHERE day = ? LIMIT 1", now,nil];
        [retSets next];
        NSString *sign = [retSets stringForColumn:@"sign"];
        _signed = sign.boolValue;
    }];
    return _signed;
}

/**
 *  @brief 今日签到
 *
 *  @param sign 是否正确的签到
 *
 *  @return 签到结果
 */
- (BOOL)signatured:(BOOL)sign {
    NSDateFormatter *formatter = self.dateFormatter;
    NSString *now = [formatter stringFromDate:[NSDate date]];
    now = [[now componentsSeparatedByString:@" "] firstObject];
    __block BOOL ret = false;
    NSString *__sign = PBFormat(@"%d",sign);
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:@"UPDATE t_daily_sign SET sign = ? WHERE day = ? ", __sign, now, nil];
        NSLog(@"ret:%zd---更新数据",ret);
    }];
    
    return ret;
}

#pragma mark -- 首页 Banner

/**
 *  @brief 获取缓存的banner
 *
 *  @return banner
 */
- (NSDictionary *)getBanner {
    return nil;
}

/**
 *  @brief 缓存banner
 *
 *  @param banner 信息
 *
 *  @return 缓存结果
 */
- (BOOL)saveBanner:(NSDictionary *)banner {
    return false;
}

#pragma mark -- 首页 第一页活动数据

/**
 *  @brief 获取缓存活动
 *
 *  @return 活动
 */
- (NSArray *)getActivities {
    __block NSMutableArray *tmpArray = [NSMutableArray array];
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///处理事情
        [db setKey:NHDBCipherKey];
        FMResultSet *retSets = [db executeQuery:@"SELECT * FROM t_plat_activity",nil];
        while ([retSets next]) {
            NSString *platid = [retSets stringForColumn:@"platid"];
            NSString *name = [retSets stringForColumn:@"name"];
            NSString *icon = [retSets stringForColumn:@"icon"];
            NSString *actString = [retSets stringForColumn:@"activities"];
            NSData *actData = [actString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *acts = [NSJSONSerialization JSONObjectWithData:actData options:NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:nil];
            NSDictionary *tmp = [NSDictionary dictionaryWithObjectsAndKeys:platid,@"id",name,@"name",icon,@"icon",acts,@"activity", nil];
            [tmpArray addObject:tmp];
        }
    }];
    
    return [tmpArray copy];
}

- (BOOL)clearExpiredActivities {
    __block BOOL ret = false;
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:@"DELETE FROM t_plat_activity",nil];
        NSLog(@"ret:%zd---删除数据",ret);
    }];
    
    return ret;
}

/**
 *  @brief 缓存第一页活动列表
 *
 *  @param list 列表
 *
 *  @return 缓存结果
 */
- (BOOL)saveActivities:(NSDictionary *)activity {
    __block BOOL ret = false;
    
    if (activity == nil) {
        return ret;
    }
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *mSQL = @"INSERT INTO t_plat_activity (platid, name, icon, activity) VALUES(?, ?, ?, ?)";
        NSString *platid = [activity objectForKey:@"id"];
        NSString *name = [activity objectForKey:@"name"];
        NSString *icon = [activity objectForKey:@"icon"];
        NSArray *activities = [activity objectForKey:@"activity"];
        NSData *actData = [NSJSONSerialization dataWithJSONObject:activities options:NSJSONWritingPrettyPrinted error:nil];
        NSString *actString = [[NSString alloc] initWithData:actData encoding:NSUTF8StringEncoding];
        NSMutableArray *params = [NSMutableArray array];
        [params addObject:platid];
        [params addObject:name];
        [params addObject:icon];
        [params addObject:actString];
        ///执行SQL语句
        [db setKey:NHDBCipherKey];
        ret = [db executeUpdate:mSQL withArgumentsInArray:params];
        NSLog(@"ret:%zd---插入数据",ret);
    }];
    
    return ret;
}

@end
