include "../common/common.thrift"

namespace java com.sankuai.qcs.dispatchexp.thrift

struct SceneInfo {
    1: required string name
    2: required string appKey
    3: optional string description
}

struct SceneResult {
    1: common.ErrorCode code
    2: optional list<SceneInfo> scenes
}

struct ABDimensionInfo {
    1: required string appKey
    2: required string dimName
    3: optional string description
}

struct ABDimensionResult {
    1: common.ErrorCode code
    2: optional list<ABDimensionInfo> abDimensions
}

struct WholeConfigSetResult {
    1: common.ErrorCode code
    2: optional list<string> wholeConfigs
}

struct ConfigKV {
    1: optional string configKey
    2: optional string configValue
}

// 发布层配置
struct LaunchLayerConfig {
    1: optional string layerName
    2: optional list<ConfigKV> configs
}

struct DomainConfig {
    1: optional string domainName
    2: optional list<ConfigKV> configKVs
    3: optional i32 flowBucket
}

// 普通层配置
struct GeneralLayerConfig {
    1: optional string layerName
    2: optional list<DomainConfig> domainConfigList
}

// 垂直域配置
struct NonOverlappingDomainConfig {
    1: optional list<LaunchLayerConfig> launchLayerConfigs
}

// 垂直域 and 普通域 分流控制
struct NonOverlappingAndGeneralDomainFlowControl {
    1: optional i32 nonOverlappingDomainBucket
    2: optional i32 generalLayerDomainBucket
}

// 分层框架模型
struct InfrastructureConfig {
    1: optional list<LaunchLayerConfig> launchLayerConfigs
    2: optional list<GeneralLayerConfig> generalLayerConfigs
    3: optional NonOverlappingDomainConfig nonOverlappingDomainConfig
    4: optional NonOverlappingAndGeneralDomainFlowControl nonOverlappingAndGeneralDomainFlowControl
}

// group 分层框架模型
struct GroupInfrastructureConfig {
    1: optional string groupName
    2: optional InfrastructureConfig infrastructureConfig
    3: optional i32 status // status=0  staged 状态; status=1 commit 状态
}

// dimension 下的分层框架模型
struct DimensionInfrastructureConfig {
    1: required string dimName
    2: optional list<GroupInfrastructureConfig> groupInfrastructureConfigs
}

// dimension 下某个 group 分层框架模型
struct DimensionGroupInfrastructureConfig {
    1: required string dimName
    2: required GroupInfrastructureConfig groupInfrastructureConfig
}

struct DimensionGroup {
    1: optional string dimName
    2: optional string groupName
    3: optional i32 status // status=0  staged 状态; status=1 commit 状态
}

struct DimensionGroupManage {
    1: required string description
    2: required InfrastructureConfig infrastructureConfig
}

struct DimensionGroupCreate {
    1: required string groupName
    2: required DimensionGroupManage dimensionGroupManage
    3: optional i32 status // status=0  staged 状态; status=1 commit 状态
}

struct DimensionGroupResult {
    1: common.ErrorCode code
    2: optional list<DimensionGroupCreate> dimensionGroupCreateList
}

struct DimensionGroupCities {
    1: required i64 cityId
    2: required string cityName
    3: optional string groupName
    4: optional i64 ctime
    5: optional i32 status // status=0  staged 状态; status=1 commit 状态
}

struct DimensionGroupCitiesResult {
    1: common.ErrorCode code
    2: optional list<DimensionGroupCities> cities
}

struct CityInfo {
    1: required i64 cityId
    2: required string cityName
    3: optional i64 ctime
    4: optional list<DimensionGroup> dimensionGroups
}

struct CityInfoResult {
    1: common.ErrorCode code
    2: optional list<CityInfo> cities
}

struct HistoryInfoRequest {
    1: required string appKey
    2: required string dim
    3: required string groupName
    4: required string operator;
}

struct RelateCities {
    1: optional list<CityInfo> cityInfos
}

struct HistoryInfo {
    1: required string appKey
    2: required string dim
    3: required string groupName
    4: optional i64 time
    5: required i32 status  // status=0 可以commit, clear; status=1 不可以commit, clear
    6: optional InfrastructureConfig oldInfrastructureConfig
    7: optional InfrastructureConfig newInfrastructureConfig
    8: optional RelateCities oldCities
    9: optional RelateCities newCities;
    10: optional string operator
}

struct HistoryResult {
    1: common.ErrorCode code
    2: optional list<HistoryInfo> historyInfoList
}

struct PrefixResult {
    1: common.ErrorCode code
    2: optional string prefix
}

struct UpdateCityInfoConfigReq {
    1: required string appKey
    2: required i64 cityId
    3: required string cityName
    4: required string dimName
    5: required string groupName
    6: required InfrastructureConfig infrastructureConfig
}

service DispatchExpThriftService {
    // <!-- start scene -- >
    //获取在该环境下,所有 scene
    SceneResult getScenes()

    // 在该环境下，新增 scene
    common.Response createScene(1: SceneInfo sceneInfo)
    // <!-- end scene -- >

    // <!-- start dimension -- >
    //获取在该环境以及该 appKey 下的所有实验维度
    ABDimensionResult getABDimensions(1: string appKey)

    // 在该环境以及该 appKey 下新增 abDimension
    common.Response createABDimension(1: ABDimensionInfo abDimensionInfo)
    // <!-- end dimension -- >

    // <!-- start 全局配置 -- >
    //获取在该环境下,本appKey下的全局配置
    WholeConfigSetResult getABDimensionWholeConfigSet(1: string appKey)
    // <!-- end 全局配置 -- >

    // <!-- 城市配置 -->
    //获取在该环境以及该 appKey 下的所有city的配置
    CityInfoResult getAllCityInfoResult(1: string appKey)

    // 新建城市
    common.Response createCityInfo(1: string appKey, 2: CityInfo cityInfo)

    // 更新City配置
    common.Response updateCityInfo(1: string appKey, 2: CityInfo cityInfo)

    // 获取所有维度DIM 下所有GROUP
    list<DimensionInfrastructureConfig> getAllDimensionGroupConfig(1: string appKey)

    // 获取某个维度DIM 下所有GROUP
    DimensionInfrastructureConfig getDimensionGroupConfig(1: string appKey, 2: string dimName)

    //获取在该环境以及该 appKey 下指定 city 配置
    CityInfo getCityInfoAllDimensionConfig(1: string appKey, 2: i64 cityId)

    // <!-- start 实验框架 -- >
    // 获取在该环境以及该 appKey 下某个维度DIM指定 city 配置
    GroupInfrastructureConfig getCityInfoConfig(1: string appKey, 2: string dimName, 3: i64 cityId)

    //在该环境以及该 appKey 下修改某个维度下 city 配置(个性化城市配置)
    common.Response updateCityInfoConfig(1: UpdateCityInfoConfigReq updateCityInfoConfigReq)
    // <!-- end 实验框架 -- >

    // <!-- start 分城配置 -- >
    // <!-- group -->
    //获取在该环境以及该 appKey 下某个维度DIM的group
    DimensionGroupResult getDimensionGroupResult(1: string appKey, 2: string dimName)

    // 在该环境以及该 appKey 下某个维度DIM新增group
    common.Response createDimensionGroup(1: string appKey, 2: string dimName, 3: DimensionGroupCreate dimensionGroupCreate)

    // 在该环境以及该 appKey 下某个维度DIM修改group
    common.Response updateDimensionGroup(1: string appKey, 2: string dimName, 3: string groupName, 4: DimensionGroupManage dimensionGroupManage)
    // <!-- end group -->

    // <!-- city -->
    //获取在该环境以及该 appKey 下某个维度DIM的city
    DimensionGroupCitiesResult getDimensionCityInfoResult(1: string appKey, 2: string dimName)
   // <!-- end city -->
    // <!-- end 分城配置 -- >

    // 获取 history
    HistoryResult getHistory(1: string appKey)

    // commit history
    common.Response commitHistory(1: HistoryInfoRequest historyInfoRequest)

    // clear history
    common.Response clearHistory(1: HistoryInfoRequest historyInfoRequest)

    // reset history
    common.Response resetHistory(1: HistoryInfoRequest historyInfoRequest)

    // check duplicate name
    common.Response checkDuplicateGroupName(1: string appKey, 2: string dimName, 3: string groupName)

    // check duplicate city
    common.Response checkDuplicateCity(1: string appKey, 2: i64 cityId)

    // naming specification
    PrefixResult getDimensionPrefix(1: string appKey, 2: string dimName)
}