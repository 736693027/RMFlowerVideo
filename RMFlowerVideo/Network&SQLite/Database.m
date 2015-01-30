//
//  Database.m
//  jumeiyouping
//
//  Created by qianfeng on 13-3-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Database.h"

#define DATABASENAME @"SQLite.db"
#define PLAYHISTORYLISTNAME @"PlayHistoryListname"
#define DOWNLOADLISTNAME @"DownLoadListname"

static Database *gl_database=nil;
@implementation Database

-(id)init
{
    if(self=[super init])
    {
        [self creatDatabaseWithListName:nil];
    }
    return self;
}

//实例化数据库
+(Database *)sharedDatabase
{
    if(!gl_database)
    {
        gl_database = [[Database alloc] init];
    }
    return gl_database;
}

//创建数据库文件目录
+(NSString *)filePath:(NSString *)fileName
{
    NSString *rootPath = NSHomeDirectory();
    rootPath = [rootPath stringByAppendingPathComponent:@"Library/Caches"];
    if(fileName&&[fileName length]!=0)
    {
        rootPath = [rootPath stringByAppendingPathComponent:fileName];
    }
    
    return rootPath;
}

//创建表
-(void)creatDatabaseWithListName:(NSString *)listName
{
    NSString *filepath = [Database filePath:DATABASENAME];
    
    mdb = [FMDatabase databaseWithPath:filepath];
    
    if([mdb open])
    {
        NSString *playHistoryNameSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (serial integer  Primary Key Autoincrement,titleImage TEXT(1024) DEFAULT NULL,titleName TEXT(1024),actors TEXT(1024),directors TEXT(1024),playCount TEXT(1024),movieURL TEXT(1024),playTime TEXT(1024),video_id TEXT(1024),weburl TEXT(1024) DEFAULT NULL)",PLAYHISTORYLISTNAME];
        
        NSString *downLoadSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (serial integer  Primary Key Autoincrement,titleImage TEXT(1024) DEFAULT NULL,titleName TEXT(1024),actors TEXT(1024),directors TEXT(1024),playCount TEXT(1024),totalMamery TEXT(1024),videoID TEXT(1024) DEFAULT NULL)",DOWNLOADLISTNAME];
       
        if(![mdb executeUpdate:playHistoryNameSql]||![mdb executeUpdate:downLoadSql])
        {
            NSLog(@"创建表失败");
        }
    }
    [mdb close];
}

//-(void)updatecountnum:(NSString *)itemID count:(NSString *)count
//{
//    NSString *sql = [NSString stringWithFormat:@"update %@ set countnum=? where titleName=?",PLAYHISTORYLISTNAME,count,itemID];
//    if([mdb executeUpdate:sql,count,itemID]){
//        NSLog(@"更新成功");
//    }
//    else{
//        NSLog(@"更新失败");
//    }
//}

/***************************************数据库操作的公共方法***********************************************************/
//删除数据库中表中的数据
-(void)deleteAllDataSourceFromListName:(NSString *)listName;
{
    if([mdb open]){
        NSString *sql = [NSString stringWithFormat:@"delete from %@",listName];
        if([mdb executeUpdate:sql]){
            NSLog(@"删除成功");
        }
        else{
            NSLog(@"删除失败");
        }
    }
    [mdb close];
}
//表中数据个数
-(NSInteger)itemcountFromListName:(NSString *)listName {
    if([mdb open]){
        NSString *sql = [NSString stringWithFormat:@"select count(*) from %@",listName];
        FMResultSet *rs = [mdb executeQuery:sql];
        while ([rs next]) {
            NSInteger count = [rs intForColumnIndex:0];
            [mdb close];
            return count;
        }
    }
    [mdb close];
    return 0;
}

//删除某一条
-(void)deleteItem:(RMPublicModel *)item fromListName:(NSString *)listName{
    
    if([mdb open]){
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where titleName='%@'",listName,item.name];
        if([mdb executeUpdate:sql]){
            NSLog(@"删除成功");
        }
        else{
            NSLog(@"删除失败");
        }
    }
    [mdb close];
}

/***************************************以下为观看记录数据库操作***********************************************************/

//判断所插入观看历史记录的数据是否已经在数据库中，避免重复插入
-(BOOL)isExistHistoryItem:(RMPublicModel *)item FromListName:(NSString *)listName
{
    NSString *sql = [NSString stringWithFormat:@"select titleName from %@ where titleName=?",listName];
    FMResultSet *rs = [mdb executeQuery:sql,item.name];
    while ([rs next]) {
        return YES;
    }
    return NO;
}

//删除第一条数据
- (void)deletFristItem{
    NSArray *array = [self readitemFromHistroyList];
    [self deleteItem:[array objectAtIndex:0] fromListName:PLAYHISTORYLISTNAME];
}
//插入单条观看记录数据
-(void)insertHistoryMovieItem:(RMPublicModel *)item
{
   if([mdb open]){
        if([self isExistHistoryItem:item FromListName:PLAYHISTORYLISTNAME])
        {
            [self deleteItem:item fromListName:PLAYHISTORYLISTNAME];
        }
        if([self itemcountFromListName:PLAYHISTORYLISTNAME]>20){
            [self deletFristItem];
        }
       [mdb open];
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (titleImage,titleName,actors,directors,playCount,movieURL,playTime,video_id,weburl) values (?,?,?,?,?,?,?,?,?)",PLAYHISTORYLISTNAME];
        if([mdb executeUpdate:sql,item.pic,item.name,item.actors,item.directors,item.hits,item.m_down_url,item.playTime,item.video_id,item.jumpurl])
        {
            NSLog(@"插入成功");
        }
        else
        {
            NSLog(@"插入失败:%@",[mdb lastErrorMessage]);
        }
    }
    [mdb close];
}
//观看记录多条数据插入
-(void)insertHistoryItemsArray:(NSMutableArray *)array {
    if([mdb open]){
        [mdb beginTransaction];
        for(RMPublicModel *item in array)
        {
            [self insertHistoryMovieItem:item];
        }
        [mdb commit];
    }
    [mdb close];
}

//读取数据
-(NSArray *)readitemFromHistroyList{
    if([mdb open]){
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        NSString *sql = [NSString stringWithFormat:@"select titleImage,titleName,actors,directors,playCount,movieURL,playTime,video_id,weburl from %@",PLAYHISTORYLISTNAME];
        FMResultSet *rs = [mdb executeQuery:sql];
        while ([rs next]) {
            RMPublicModel *item = [[RMPublicModel alloc] init];
            item.pic = [rs stringForColumn:@"titleImage"];
            item.name = [rs stringForColumn:@"titleName"];
            item.actors = [rs stringForColumn:@"actors"];
            item.directors = [rs stringForColumn:@"directors"];
            item.hits = [rs stringForColumn:@"playCount"];
            item.m_down_url = [rs stringForColumn:@"movieURL"];
            item.playTime = [rs stringForColumn:@"playTime"];
            item.video_id = [rs stringForColumn:@"video_id"];
            item.jumpurl = [rs stringForColumn:@"weburl"];
            [array addObject:item];
        }
        [mdb close];
        return array;
    }
    [mdb close];
    return nil;
}

/***************************************如下为已缓存的数据库操作***********************************************************/

- (void)insertDownLoadMovieItem:(RMPublicModel *)item{
    if([mdb open]){
        if([self isExistHistoryItem:item FromListName:DOWNLOADLISTNAME])
        {
            [self deleteItem:item fromListName:DOWNLOADLISTNAME];
        }
        NSString *sql = [NSString stringWithFormat:@"insert into DownLoadListname (titleImage,titleName,actors,directors,playCount,totalMamery,videoID) values (?,?,?,?,?,?,?)"];
        if([mdb executeUpdate:sql,item.pic,item.name,item.actors,item.directors,item.hits,item.totalMemory,item.video_id])
        {
            NSLog(@"插入成功");
        }
        else
        {
            NSLog(@"插入失败:%@",[mdb lastErrorMessage]);
        }
    }
    [mdb close];
}


- (void)insertDownLoadItemsArray:(NSMutableArray *)dowaLoadArray {
    if([mdb open]){
        [mdb beginTransaction];
            for(RMPublicModel *item in dowaLoadArray)
            {
                [self insertDownLoadMovieItem:item];
            }
        [mdb commit];
    }
    [mdb close];

}

- (NSArray *)readItemFromDownLoadList{
    if([mdb open]){
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        NSString *sql = [NSString stringWithFormat:@"select titleImage,titleName,actors,directors,playCount,totalMamery,videoID from DownLoadListname"];
        FMResultSet *rs = [mdb executeQuery:sql];
        while ([rs next]) {
            RMPublicModel *item = [[RMPublicModel alloc] init];
            item.pic = [rs stringForColumn:@"titleImage"];
            item.name = [rs stringForColumn:@"titleName"];
            item.actors = [rs stringForColumn:@"actors"];
            item.directors = [rs stringForColumn:@"directors"];
            item.hits = [rs stringForColumn:@"playCount"];
            item.totalMemory = [rs stringForColumn:@"totalMamery"];
            item.video_id = [rs stringForColumn:@"videoID"];
            [array addObject:item];
        }
        [mdb close];
        return array;
    }
    [mdb close];
    return nil;
}

//这个方法主要是在添加下载的时候，判断时候已经下载过了
- (BOOL)isDownLoadMovieWith:(RMPublicModel *)model{
    if([mdb open]){
        NSString *sql = [NSString stringWithFormat:@"select titleName from DownLoadListname where titleName=?"];
        FMResultSet *rs = [mdb executeQuery:sql,model.name];
        while ([rs next]) {
            [mdb close];
            return YES;
        }
    }
    return NO;
}
//该方法主要是判断某个电视剧是否已经下载过了
- (BOOL)isDownLoadMovieWithModelName:(NSString *)modelName{
    if([mdb open]){
        NSString *sql = [NSString stringWithFormat:@"select titleName from DownLoadListname where titleName=?"];
        FMResultSet *rs = [mdb executeQuery:sql,modelName];
        while ([rs next]) {
            [mdb close];
            return YES;
        }
    }
    return NO;
}


/*
 1、创建数据库 在AppDelete中
 [Database sharedDatabase];
 2、查询条数
 NSUInteger num = [[Database sharedDatabase] itemcountFromListName:CITYNAMELISTNAME andProvinceID:self.provinceID];
 3、读取数据
 NSArray *array = [[Database sharedDatabase] readitemFromListName:CITYNAMELISTNAME andProvinceID:self.provinceID];
 4、插入数据库
 //将下载结果插入数据库中
 [[Database sharedDatabase] insertArray:tmpModel.array toListName:CITYNAMELISTNAME andProvinveID:self.provinceID];
 */

@end
