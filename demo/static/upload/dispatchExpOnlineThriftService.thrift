include "../common/common.thrift"

namespace java com.sankuai.qcs.dispatchexp.thrift

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

// dimension 下 分层框架模型
struct DimensionRealInfrastructureConfig {
    1: required string dimName
    2: required InfrastructureConfig infrastructureConfig
}

struct CityInfoConfig {
     1: required i64 cityId
     2: required string cityName
     3: optional list<DimensionRealInfrastructureConfig> dimensionRealInfrastructureConfigList
}

struct GetAllCityInfoConfigResponse {
     1: common.ErrorCode code
     2: optional list<CityInfoConfig> cityInfoConfigs
}

struct GetAllCityInfoResultRequest {
    1: required string appKey
    2: optional list<i64> cities;
    3: optional list<string> dimList
}

service DispatchExpOnlineThriftService {

    //获取在该环境以及该 appKey 下的指定维度的所有城市配置
    GetAllCityInfoConfigResponse getAllCityInfoResult(1: required GetAllCityInfoResultRequest getAllCityInfoResultRequest)
}