local ffi = require("ffi")

ffi.cdef[[
// --- Base Types ---
typedef void* PFN_vkVoidFunction;
typedef void* PFN_vkAllocationFunction;
typedef void* PFN_vkReallocationFunction;
typedef void* PFN_vkFreeFunction;
typedef void* PFN_vkInternalAllocationNotification;
typedef void* PFN_vkInternalFreeNotification;

// --- Handles ---
typedef struct VkInstance_T* VkInstance;
typedef struct VkPhysicalDevice_T* VkPhysicalDevice;
typedef struct VkDevice_T* VkDevice;
typedef struct VkQueue_T* VkQueue;
typedef struct VkCommandBuffer_T* VkCommandBuffer;
typedef struct VkDeviceMemory_T* VkDeviceMemory;
typedef struct VkCommandPool_T* VkCommandPool;
typedef struct VkBuffer_T* VkBuffer;
typedef struct VkBufferView_T* VkBufferView;
typedef struct VkImage_T* VkImage;
typedef struct VkImageView_T* VkImageView;
typedef struct VkShaderModule_T* VkShaderModule;
typedef struct VkPipeline_T* VkPipeline;
typedef struct VkPipelineLayout_T* VkPipelineLayout;
typedef struct VkSampler_T* VkSampler;
typedef struct VkDescriptorSet_T* VkDescriptorSet;
typedef struct VkDescriptorSetLayout_T* VkDescriptorSetLayout;
typedef struct VkDescriptorPool_T* VkDescriptorPool;
typedef struct VkFence_T* VkFence;
typedef struct VkSemaphore_T* VkSemaphore;
typedef struct VkEvent_T* VkEvent;
typedef struct VkQueryPool_T* VkQueryPool;
typedef struct VkFramebuffer_T* VkFramebuffer;
typedef struct VkRenderPass_T* VkRenderPass;
typedef struct VkPipelineCache_T* VkPipelineCache;
typedef struct VkPipelineBinaryKHR_T* VkPipelineBinaryKHR;
typedef struct VkIndirectCommandsLayoutNV_T* VkIndirectCommandsLayoutNV;
typedef struct VkIndirectCommandsLayoutEXT_T* VkIndirectCommandsLayoutEXT;
typedef struct VkIndirectExecutionSetEXT_T* VkIndirectExecutionSetEXT;
typedef struct VkDescriptorUpdateTemplate_T* VkDescriptorUpdateTemplate;
typedef struct VkSamplerYcbcrConversion_T* VkSamplerYcbcrConversion;
typedef struct VkValidationCacheEXT_T* VkValidationCacheEXT;
typedef struct VkAccelerationStructureKHR_T* VkAccelerationStructureKHR;
typedef struct VkAccelerationStructureNV_T* VkAccelerationStructureNV;
typedef struct VkPerformanceConfigurationINTEL_T* VkPerformanceConfigurationINTEL;
typedef struct VkBufferCollectionFUCHSIA_T* VkBufferCollectionFUCHSIA;
typedef struct VkDeferredOperationKHR_T* VkDeferredOperationKHR;
typedef struct VkPrivateDataSlot_T* VkPrivateDataSlot;
typedef struct VkCuModuleNVX_T* VkCuModuleNVX;
typedef struct VkCuFunctionNVX_T* VkCuFunctionNVX;
typedef struct VkOpticalFlowSessionNV_T* VkOpticalFlowSessionNV;
typedef struct VkMicromapEXT_T* VkMicromapEXT;
typedef struct VkShaderEXT_T* VkShaderEXT;
typedef struct VkTensorARM_T* VkTensorARM;
typedef struct VkTensorViewARM_T* VkTensorViewARM;
typedef struct VkDataGraphPipelineSessionARM_T* VkDataGraphPipelineSessionARM;
typedef struct VkDisplayKHR_T* VkDisplayKHR;
typedef struct VkDisplayModeKHR_T* VkDisplayModeKHR;
typedef struct VkSurfaceKHR_T* VkSurfaceKHR;
typedef struct VkSwapchainKHR_T* VkSwapchainKHR;
typedef struct VkDebugReportCallbackEXT_T* VkDebugReportCallbackEXT;
typedef struct VkDebugUtilsMessengerEXT_T* VkDebugUtilsMessengerEXT;
typedef struct VkVideoSessionKHR_T* VkVideoSessionKHR;
typedef struct VkVideoSessionParametersKHR_T* VkVideoSessionParametersKHR;
typedef struct VkSemaphoreSciSyncPoolNV_T* VkSemaphoreSciSyncPoolNV;
typedef struct VkCudaModuleNV_T* VkCudaModuleNV;
typedef struct VkCudaFunctionNV_T* VkCudaFunctionNV;
typedef struct VkExternalComputeQueueNV_T* VkExternalComputeQueueNV;

// --- Enums & Bitmasks ---
typedef uint32_t VkSampleMask;
typedef uint32_t VkBool32;
typedef uint32_t VkFlags;
typedef uint64_t VkFlags64;
typedef uint64_t VkDeviceSize;
typedef uint64_t VkDeviceAddress;
typedef VkFlags VkFramebufferCreateFlags;
typedef VkFlags VkQueryPoolCreateFlags;
typedef VkFlags VkRenderPassCreateFlags;
typedef VkFlags VkSamplerCreateFlags;
typedef VkFlags VkPipelineLayoutCreateFlags;
typedef VkFlags VkPipelineCacheCreateFlags;
typedef VkFlags VkPipelineDepthStencilStateCreateFlags;
typedef VkFlags VkPipelineDynamicStateCreateFlags;
typedef VkFlags VkPipelineColorBlendStateCreateFlags;
typedef VkFlags VkPipelineMultisampleStateCreateFlags;
typedef VkFlags VkPipelineRasterizationStateCreateFlags;
typedef VkFlags VkPipelineViewportStateCreateFlags;
typedef VkFlags VkPipelineTessellationStateCreateFlags;
typedef VkFlags VkPipelineInputAssemblyStateCreateFlags;
typedef VkFlags VkPipelineVertexInputStateCreateFlags;
typedef VkFlags VkPipelineShaderStageCreateFlags;
typedef VkFlags VkDescriptorSetLayoutCreateFlags;
typedef VkFlags VkBufferViewCreateFlags;
typedef VkFlags VkInstanceCreateFlags;
typedef VkFlags VkDeviceCreateFlags;
typedef VkFlags VkDeviceQueueCreateFlags;
typedef VkFlags VkQueueFlags;
typedef VkFlags VkMemoryPropertyFlags;
typedef VkFlags VkMemoryHeapFlags;
typedef VkFlags VkAccessFlags;
typedef VkFlags VkBufferUsageFlags;
typedef VkFlags VkBufferCreateFlags;
typedef VkFlags VkShaderStageFlags;
typedef VkFlags VkImageUsageFlags;
typedef VkFlags VkImageCreateFlags;
typedef VkFlags VkImageViewCreateFlags;
typedef VkFlags VkPipelineCreateFlags;
typedef VkFlags VkColorComponentFlags;
typedef VkFlags VkFenceCreateFlags;
typedef VkFlags VkSemaphoreCreateFlags;
typedef VkFlags VkFormatFeatureFlags;
typedef VkFlags VkQueryControlFlags;
typedef VkFlags VkQueryResultFlags;
typedef VkFlags VkShaderModuleCreateFlags;
typedef VkFlags VkEventCreateFlags;
typedef VkFlags VkCommandPoolCreateFlags;
typedef VkFlags VkCommandPoolResetFlags;
typedef VkFlags VkCommandBufferResetFlags;
typedef VkFlags VkCommandBufferUsageFlags;
typedef VkFlags VkQueryPipelineStatisticFlags;
typedef VkFlags VkMemoryMapFlags;
typedef VkFlags VkMemoryUnmapFlags;
typedef uint32_t VkMemoryUnmapFlagsKHR;
typedef VkFlags VkImageAspectFlags;
typedef VkFlags VkSparseMemoryBindFlags;
typedef VkFlags VkSparseImageFormatFlags;
typedef VkFlags VkSubpassDescriptionFlags;
typedef VkFlags VkPipelineStageFlags;
typedef VkFlags VkSampleCountFlags;
typedef VkFlags VkAttachmentDescriptionFlags;
typedef VkFlags VkStencilFaceFlags;
typedef VkFlags VkCullModeFlags;
typedef VkFlags VkDescriptorPoolCreateFlags;
typedef VkFlags VkDescriptorPoolResetFlags;
typedef VkFlags VkDependencyFlags;
typedef VkFlags VkSubgroupFeatureFlags;
typedef VkFlags VkIndirectCommandsLayoutUsageFlagsNV;
typedef VkFlags VkIndirectStateFlagsNV;
typedef VkFlags VkGeometryFlagsKHR;
typedef uint32_t VkGeometryFlagsNV;
typedef VkFlags VkGeometryInstanceFlagsKHR;
typedef uint32_t VkGeometryInstanceFlagsNV;
typedef VkFlags VkClusterAccelerationStructureGeometryFlagsNV;
typedef VkFlags VkClusterAccelerationStructureClusterFlagsNV;
typedef VkFlags VkClusterAccelerationStructureAddressResolutionFlagsNV;
typedef VkFlags VkBuildAccelerationStructureFlagsKHR;
typedef uint32_t VkBuildAccelerationStructureFlagsNV;
typedef VkFlags VkPrivateDataSlotCreateFlags;
typedef uint32_t VkPrivateDataSlotCreateFlagsEXT;
typedef VkFlags VkAccelerationStructureCreateFlagsKHR;
typedef VkFlags VkDescriptorUpdateTemplateCreateFlags;
typedef uint32_t VkDescriptorUpdateTemplateCreateFlagsKHR;
typedef VkFlags VkPipelineCreationFeedbackFlags;
typedef uint32_t VkPipelineCreationFeedbackFlagsEXT;
typedef VkFlags VkPerformanceCounterDescriptionFlagsKHR;
typedef VkFlags VkAcquireProfilingLockFlagsKHR;
typedef VkFlags VkSemaphoreWaitFlags;
typedef uint32_t VkSemaphoreWaitFlagsKHR;
typedef VkFlags VkPipelineCompilerControlFlagsAMD;
typedef VkFlags VkShaderCorePropertiesFlagsAMD;
typedef VkFlags VkDeviceDiagnosticsConfigFlagsNV;
typedef VkFlags VkRefreshObjectFlagsKHR;
typedef VkFlags64 VkAccessFlags2;
typedef uint32_t VkAccessFlags2KHR;
typedef VkFlags64 VkPipelineStageFlags2;
typedef uint32_t VkPipelineStageFlags2KHR;
typedef VkFlags VkAccelerationStructureMotionInfoFlagsNV;
typedef VkFlags VkAccelerationStructureMotionInstanceFlagsNV;
typedef VkFlags64 VkFormatFeatureFlags2;
typedef uint32_t VkFormatFeatureFlags2KHR;
typedef VkFlags VkRenderingFlags;
typedef VkFlags64 VkMemoryDecompressionMethodFlagsEXT;
typedef uint32_t VkMemoryDecompressionMethodFlagsNV;
typedef uint32_t VkRenderingFlagsKHR;
typedef VkFlags VkBuildMicromapFlagsEXT;
typedef VkFlags VkMicromapCreateFlagsEXT;
typedef VkFlags VkIndirectCommandsLayoutUsageFlagsEXT;
typedef VkFlags VkIndirectCommandsInputModeFlagsEXT;
typedef VkFlags VkDirectDriverLoadingFlagsLUNARG;
typedef VkFlags64 VkPipelineCreateFlags2;
typedef uint32_t VkPipelineCreateFlags2KHR;
typedef VkFlags64 VkBufferUsageFlags2;
typedef uint32_t VkBufferUsageFlags2KHR;
typedef VkFlags VkAddressCopyFlagsKHR;
typedef VkFlags64 VkTensorCreateFlagsARM;
typedef VkFlags64 VkTensorUsageFlagsARM;
typedef VkFlags64 VkTensorViewCreateFlagsARM;
typedef VkFlags64 VkDataGraphPipelineSessionCreateFlagsARM;
typedef VkFlags64 VkDataGraphPipelineDispatchFlagsARM;
typedef VkFlags VkVideoEncodeRgbModelConversionFlagsVALVE;
typedef VkFlags VkVideoEncodeRgbRangeCompressionFlagsVALVE;
typedef VkFlags VkVideoEncodeRgbChromaOffsetFlagsVALVE;
typedef VkFlags VkSpirvResourceTypeFlagsEXT;
typedef VkFlags VkCompositeAlphaFlagsKHR;
typedef VkFlags VkDisplayPlaneAlphaFlagsKHR;
typedef VkFlags VkSurfaceTransformFlagsKHR;
typedef VkFlags VkSwapchainCreateFlagsKHR;
typedef VkFlags VkDisplayModeCreateFlagsKHR;
typedef VkFlags VkDisplaySurfaceCreateFlagsKHR;
typedef VkFlags VkAndroidSurfaceCreateFlagsKHR;
typedef VkFlags VkViSurfaceCreateFlagsNN;
typedef VkFlags VkWaylandSurfaceCreateFlagsKHR;
typedef VkFlags VkWin32SurfaceCreateFlagsKHR;
typedef VkFlags VkXlibSurfaceCreateFlagsKHR;
typedef VkFlags VkXcbSurfaceCreateFlagsKHR;
typedef VkFlags VkDirectFBSurfaceCreateFlagsEXT;
typedef VkFlags VkIOSSurfaceCreateFlagsMVK;
typedef VkFlags VkMacOSSurfaceCreateFlagsMVK;
typedef VkFlags VkMetalSurfaceCreateFlagsEXT;
typedef VkFlags VkImagePipeSurfaceCreateFlagsFUCHSIA;
typedef VkFlags VkStreamDescriptorSurfaceCreateFlagsGGP;
typedef VkFlags VkHeadlessSurfaceCreateFlagsEXT;
typedef VkFlags VkScreenSurfaceCreateFlagsQNX;
typedef VkFlags VkPeerMemoryFeatureFlags;
typedef uint32_t VkPeerMemoryFeatureFlagsKHR;
typedef VkFlags VkMemoryAllocateFlags;
typedef uint32_t VkMemoryAllocateFlagsKHR;
typedef VkFlags VkDeviceGroupPresentModeFlagsKHR;
typedef VkFlags VkDebugReportFlagsEXT;
typedef VkFlags VkCommandPoolTrimFlags;
typedef uint32_t VkCommandPoolTrimFlagsKHR;
typedef VkFlags VkExternalMemoryHandleTypeFlagsNV;
typedef VkFlags VkClusterAccelerationStructureIndexFormatFlagsNV;
typedef VkFlags VkExternalMemoryFeatureFlagsNV;
typedef VkFlags VkExternalMemoryHandleTypeFlags;
typedef uint32_t VkExternalMemoryHandleTypeFlagsKHR;
typedef VkFlags VkExternalMemoryFeatureFlags;
typedef uint32_t VkExternalMemoryFeatureFlagsKHR;
typedef VkFlags VkExternalSemaphoreHandleTypeFlags;
typedef uint32_t VkExternalSemaphoreHandleTypeFlagsKHR;
typedef VkFlags VkExternalSemaphoreFeatureFlags;
typedef uint32_t VkExternalSemaphoreFeatureFlagsKHR;
typedef VkFlags VkSemaphoreImportFlags;
typedef uint32_t VkSemaphoreImportFlagsKHR;
typedef VkFlags VkExternalFenceHandleTypeFlags;
typedef uint32_t VkExternalFenceHandleTypeFlagsKHR;
typedef VkFlags VkExternalFenceFeatureFlags;
typedef uint32_t VkExternalFenceFeatureFlagsKHR;
typedef VkFlags VkFenceImportFlags;
typedef uint32_t VkFenceImportFlagsKHR;
typedef VkFlags VkSurfaceCounterFlagsEXT;
typedef VkFlags VkPipelineViewportSwizzleStateCreateFlagsNV;
typedef VkFlags VkPipelineDiscardRectangleStateCreateFlagsEXT;
typedef VkFlags VkPipelineCoverageToColorStateCreateFlagsNV;
typedef VkFlags VkPipelineCoverageModulationStateCreateFlagsNV;
typedef VkFlags VkPipelineCoverageReductionStateCreateFlagsNV;
typedef VkFlags VkValidationCacheCreateFlagsEXT;
typedef VkFlags VkDebugUtilsMessageSeverityFlagsEXT;
typedef VkFlags VkDebugUtilsMessageTypeFlagsEXT;
typedef VkFlags VkDebugUtilsMessengerCreateFlagsEXT;
typedef VkFlags VkDebugUtilsMessengerCallbackDataFlagsEXT;
typedef VkFlags VkDeviceMemoryReportFlagsEXT;
typedef VkFlags VkPipelineRasterizationConservativeStateCreateFlagsEXT;
typedef VkFlags VkDescriptorBindingFlags;
typedef uint32_t VkDescriptorBindingFlagsEXT;
typedef VkFlags VkConditionalRenderingFlagsEXT;
typedef VkFlags VkResolveModeFlags;
typedef uint32_t VkResolveModeFlagsKHR;
typedef VkFlags VkPipelineRasterizationStateStreamCreateFlagsEXT;
typedef VkFlags VkPipelineRasterizationDepthClipStateCreateFlagsEXT;
typedef VkFlags VkSwapchainImageUsageFlagsANDROID;
typedef VkFlags VkToolPurposeFlags;
typedef uint32_t VkToolPurposeFlagsEXT;
typedef VkFlags VkSubmitFlags;
typedef uint32_t VkSubmitFlagsKHR;
typedef VkFlags VkImageFormatConstraintsFlagsFUCHSIA;
typedef VkFlags VkHostImageCopyFlags;
typedef uint32_t VkHostImageCopyFlagsEXT;
typedef VkFlags VkPartitionedAccelerationStructureInstanceFlagsNV;
typedef VkFlags VkImageConstraintsInfoFlagsFUCHSIA;
typedef VkFlags VkGraphicsPipelineLibraryFlagsEXT;
typedef VkFlags VkImageCompressionFlagsEXT;
typedef VkFlags VkImageCompressionFixedRateFlagsEXT;
typedef VkFlags VkExportMetalObjectTypeFlagsEXT;
typedef VkFlags VkRenderingAttachmentFlagsKHR;
typedef VkFlags VkResolveImageFlagsKHR;
typedef VkFlags VkDeviceAddressBindingFlagsEXT;
typedef VkFlags VkOpticalFlowGridSizeFlagsNV;
typedef VkFlags VkOpticalFlowUsageFlagsNV;
typedef VkFlags VkOpticalFlowSessionCreateFlagsNV;
typedef VkFlags VkOpticalFlowExecuteFlagsNV;
typedef VkFlags VkFrameBoundaryFlagsEXT;
typedef VkFlags VkPresentScalingFlagsKHR;
typedef uint32_t VkPresentScalingFlagsEXT;
typedef VkFlags VkPresentGravityFlagsKHR;
typedef uint32_t VkPresentGravityFlagsEXT;
typedef VkFlags VkShaderCreateFlagsEXT;
typedef VkFlags VkTileShadingRenderPassFlagsQCOM;
typedef VkFlags64 VkPhysicalDeviceSchedulingControlsFlagsARM;
typedef VkFlags VkSurfaceCreateFlagsOHOS;
typedef VkFlags VkPresentStageFlagsEXT;
typedef VkFlags VkPastPresentationTimingFlagsEXT;
typedef VkFlags VkPresentTimingInfoFlagsEXT;
typedef VkFlags VkSwapchainImageUsageFlagsOHOS;
typedef VkFlags VkPerformanceCounterDescriptionFlagsARM;
typedef VkFlags VkVideoCodecOperationFlagsKHR;
typedef VkFlags VkVideoCapabilityFlagsKHR;
typedef VkFlags VkVideoSessionCreateFlagsKHR;
typedef VkFlags VkVideoSessionParametersCreateFlagsKHR;
typedef VkFlags VkVideoBeginCodingFlagsKHR;
typedef VkFlags VkVideoEndCodingFlagsKHR;
typedef VkFlags VkVideoCodingControlFlagsKHR;
typedef VkFlags VkVideoDecodeUsageFlagsKHR;
typedef VkFlags VkVideoDecodeCapabilityFlagsKHR;
typedef VkFlags VkVideoDecodeFlagsKHR;
typedef VkFlags VkVideoDecodeH264PictureLayoutFlagsKHR;
typedef VkFlags VkVideoEncodeFlagsKHR;
typedef VkFlags VkVideoEncodeUsageFlagsKHR;
typedef VkFlags VkVideoEncodeContentFlagsKHR;
typedef VkFlags VkVideoEncodeCapabilityFlagsKHR;
typedef VkFlags VkVideoEncodeFeedbackFlagsKHR;
typedef VkFlags VkVideoEncodeRateControlFlagsKHR;
typedef VkFlags VkVideoEncodeRateControlModeFlagsKHR;
typedef VkFlags VkVideoEncodeIntraRefreshModeFlagsKHR;
typedef VkFlags VkVideoChromaSubsamplingFlagsKHR;
typedef VkFlags VkVideoComponentBitDepthFlagsKHR;
typedef VkFlags VkVideoEncodeH264CapabilityFlagsKHR;
typedef VkFlags VkVideoEncodeH264StdFlagsKHR;
typedef VkFlags VkVideoEncodeH264RateControlFlagsKHR;
typedef VkFlags VkVideoEncodeH265CapabilityFlagsKHR;
typedef VkFlags VkVideoEncodeH265StdFlagsKHR;
typedef VkFlags VkVideoEncodeH265RateControlFlagsKHR;
typedef VkFlags VkVideoEncodeH265CtbSizeFlagsKHR;
typedef VkFlags VkVideoEncodeH265TransformBlockSizeFlagsKHR;
typedef VkFlags VkVideoEncodeAV1CapabilityFlagsKHR;
typedef VkFlags VkVideoEncodeAV1StdFlagsKHR;
typedef VkFlags VkVideoEncodeAV1RateControlFlagsKHR;
typedef VkFlags VkVideoEncodeAV1SuperblockSizeFlagsKHR;
typedef VkFlags64 VkAccessFlags3KHR;
typedef int VkAttachmentLoadOp;
typedef int VkAttachmentStoreOp;
typedef int VkBlendFactor;
typedef int VkBlendOp;
typedef int VkBorderColor;
typedef int VkFramebufferCreateFlagBits;
typedef int VkQueryPoolCreateFlagBits;
typedef int VkRenderPassCreateFlagBits;
typedef int VkSamplerCreateFlagBits;
typedef int VkPipelineCacheHeaderVersion;
typedef int VkPipelineCacheCreateFlagBits;
typedef int VkPipelineShaderStageCreateFlagBits;
typedef int VkDescriptorSetLayoutCreateFlagBits;
typedef int VkInstanceCreateFlagBits;
typedef int VkDeviceQueueCreateFlagBits;
typedef int VkBufferCreateFlagBits;
typedef int VkBufferUsageFlagBits;
typedef int VkColorComponentFlagBits;
typedef int VkComponentSwizzle;
typedef int VkCommandPoolCreateFlagBits;
typedef int VkCommandPoolResetFlagBits;
typedef int VkCommandBufferResetFlagBits;
typedef int VkCommandBufferLevel;
typedef int VkCommandBufferUsageFlagBits;
typedef int VkCompareOp;
typedef int VkCullModeFlagBits;
typedef int VkDescriptorType;
typedef int VkDeviceCreateFlagBits;
typedef int VkDynamicState;
typedef int VkFenceCreateFlagBits;
typedef int VkPolygonMode;
typedef int VkFormat;
typedef int VkFormatFeatureFlagBits;
typedef int VkFrontFace;
typedef int VkMemoryMapFlagBits;
typedef int VkImageAspectFlagBits;
typedef int VkImageCreateFlagBits;
typedef int VkImageLayout;
typedef int VkImageTiling;
typedef int VkImageType;
typedef int VkImageUsageFlagBits;
typedef int VkImageViewCreateFlagBits;
typedef int VkImageViewType;
typedef int VkIndirectCommandsTokenTypeEXT;
typedef int VkSharingMode;
typedef int VkIndexType;
typedef int VkLogicOp;
typedef int VkMemoryHeapFlagBits;
typedef int VkAccessFlagBits;
typedef int VkMemoryPropertyFlagBits;
typedef int VkPhysicalDeviceType;
typedef int VkPipelineBindPoint;
typedef int VkPipelineCreateFlagBits;
typedef int VkPrimitiveTopology;
typedef int VkQueryControlFlagBits;
typedef int VkQueryPipelineStatisticFlagBits;
typedef int VkQueryResultFlagBits;
typedef int VkQueryType;
typedef int VkQueueFlagBits;
typedef int VkSubpassContents;
typedef int VkResult;
typedef int VkShaderStageFlagBits;
typedef int VkSparseMemoryBindFlagBits;
typedef int VkStencilFaceFlagBits;
typedef int VkStencilOp;
typedef int VkStructureType;
typedef int VkSystemAllocationScope;
typedef int VkInternalAllocationType;
typedef int VkSamplerAddressMode;
typedef int VkFilter;
typedef int VkSamplerMipmapMode;
typedef int VkVertexInputRate;
typedef int VkPipelineStageFlagBits;
typedef int VkSparseImageFormatFlagBits;
typedef int VkClusterAccelerationStructureIndexFormatFlagBitsNV;
typedef int VkClusterAccelerationStructureTypeNV;
typedef int VkClusterAccelerationStructureOpTypeNV;
typedef int VkClusterAccelerationStructureOpModeNV;
typedef int VkSampleCountFlagBits;
typedef int VkAttachmentDescriptionFlagBits;
typedef int VkDescriptorPoolCreateFlagBits;
typedef int VkDependencyFlagBits;
typedef int VkObjectType;
typedef int VkEventCreateFlagBits;
typedef int VkPipelineLayoutCreateFlagBits;
typedef int VkSemaphoreCreateFlagBits;
typedef int VkRayTracingInvocationReorderModeEXT;
typedef int VkRayTracingInvocationReorderModeNV;
typedef int VkIndirectCommandsLayoutUsageFlagBitsNV;
typedef int VkIndirectCommandsTokenTypeNV;
typedef int VkIndirectStateFlagBitsNV;
typedef int VkPrivateDataSlotCreateFlagBits;
typedef int VkPrivateDataSlotCreateFlagBitsEXT;
typedef int VkDescriptorUpdateTemplateType;
typedef int VkDescriptorUpdateTemplateTypeKHR;
typedef int VkViewportCoordinateSwizzleNV;
typedef int VkDiscardRectangleModeEXT;
typedef int VkSubpassDescriptionFlagBits;
typedef int VkPointClippingBehavior;
typedef int VkPointClippingBehaviorKHR;
typedef int VkCoverageModulationModeNV;
typedef int VkCoverageReductionModeNV;
typedef int VkValidationCacheHeaderVersionEXT;
typedef int VkShaderInfoTypeAMD;
typedef int VkQueueGlobalPriority;
typedef int VkQueueGlobalPriorityKHR;
typedef int VkQueueGlobalPriorityEXT;
typedef int VkTimeDomainKHR;
typedef int VkTimeDomainEXT;
typedef int VkConservativeRasterizationModeEXT;
typedef int VkResolveModeFlagBits;
typedef int VkResolveModeFlagBitsKHR;
typedef int VkDescriptorBindingFlagBits;
typedef int VkDescriptorBindingFlagBitsEXT;
typedef int VkConditionalRenderingFlagBitsEXT;
typedef int VkSemaphoreType;
typedef int VkSemaphoreTypeKHR;
typedef int VkGeometryFlagBitsKHR;
typedef int VkGeometryFlagBitsNV;
typedef int VkGeometryInstanceFlagBitsKHR;
typedef int VkGeometryInstanceFlagBitsNV;
typedef int VkClusterAccelerationStructureAddressResolutionFlagBitsNV;
typedef int VkClusterAccelerationStructureGeometryFlagBitsNV;
typedef int VkClusterAccelerationStructureClusterFlagBitsNV;
typedef int VkBuildAccelerationStructureFlagBitsKHR;
typedef int VkBuildAccelerationStructureFlagBitsNV;
typedef int VkAccelerationStructureCreateFlagBitsKHR;
typedef int VkBuildAccelerationStructureModeKHR;
typedef int VkCopyAccelerationStructureModeKHR;
typedef int VkCopyAccelerationStructureModeNV;
typedef int VkAccelerationStructureTypeKHR;
typedef int VkAccelerationStructureTypeNV;
typedef int VkGeometryTypeKHR;
typedef int VkGeometryTypeNV;
typedef int VkRayTracingShaderGroupTypeKHR;
typedef int VkRayTracingShaderGroupTypeNV;
typedef int VkAccelerationStructureMemoryRequirementsTypeNV;
typedef int VkAccelerationStructureBuildTypeKHR;
typedef int VkAccelerationStructureCompatibilityKHR;
typedef int VkRayTracingLssIndexingModeNV;
typedef int VkRayTracingLssPrimitiveEndCapsModeNV;
typedef int VkShaderGroupShaderKHR;
typedef int VkMemoryOverallocationBehaviorAMD;
typedef int VkDeviceDiagnosticsConfigFlagBitsNV;
typedef int VkPipelineCreationFeedbackFlagBits;
typedef int VkPipelineCreationFeedbackFlagBitsEXT;
typedef int VkPerformanceCounterScopeKHR;
typedef int VkPerformanceCounterUnitKHR;
typedef int VkPerformanceCounterStorageKHR;
typedef int VkPerformanceCounterDescriptionFlagBitsKHR;
typedef int VkAcquireProfilingLockFlagBitsKHR;
typedef int VkSemaphoreWaitFlagBits;
typedef int VkSemaphoreWaitFlagBitsKHR;
typedef int VkPerformanceConfigurationTypeINTEL;
typedef int VkQueryPoolSamplingModeINTEL;
typedef int VkPerformanceOverrideTypeINTEL;
typedef int VkPerformanceParameterTypeINTEL;
typedef int VkPerformanceValueTypeINTEL;
typedef int VkLineRasterizationMode;
typedef int VkLineRasterizationModeKHR;
typedef int VkLineRasterizationModeEXT;
typedef int VkShaderModuleCreateFlagBits;
typedef int VkPipelineCompilerControlFlagBitsAMD;
typedef int VkShaderCorePropertiesFlagBitsAMD;
typedef int VkRefreshObjectFlagBitsKHR;
typedef int VkFaultLevel;
typedef int VkFaultType;
typedef int VkFaultQueryBehavior;
typedef int VkPipelineMatchControl;
typedef int VkSciSyncClientTypeNV;
typedef int VkSciSyncPrimitiveTypeNV;
typedef int VkToolPurposeFlagBits;
typedef int VkToolPurposeFlagBitsEXT;
typedef int VkFragmentShadingRateNV;
typedef int VkFragmentShadingRateTypeNV;
typedef int VkSubpassMergeStatusEXT;
typedef int VkAccessFlagBits2;
typedef int VkAccessFlagBits2KHR;
typedef int VkPipelineStageFlagBits2;
typedef int VkPipelineStageFlagBits2KHR;
typedef int VkProvokingVertexModeEXT;
typedef int VkPipelineCacheValidationVersion;
typedef int VkImageFormatConstraintsFlagBitsFUCHSIA;
typedef int VkHostImageCopyFlagBits;
typedef int VkHostImageCopyFlagBitsEXT;
typedef int VkImageConstraintsInfoFlagBitsFUCHSIA;
typedef int VkFormatFeatureFlagBits2;
typedef int VkFormatFeatureFlagBits2KHR;
typedef int VkRenderingFlagBits;
typedef int VkRenderingFlagBitsKHR;
typedef int VkPipelineDepthStencilStateCreateFlagBits;
typedef int VkPipelineColorBlendStateCreateFlagBits;
typedef int VkImageCompressionFlagBitsEXT;
typedef int VkImageCompressionFixedRateFlagBitsEXT;
typedef int VkExportMetalObjectTypeFlagBitsEXT;
typedef int VkPipelineRobustnessBufferBehavior;
typedef int VkPipelineRobustnessBufferBehaviorEXT;
typedef int VkPipelineRobustnessImageBehavior;
typedef int VkPipelineRobustnessImageBehaviorEXT;
typedef int VkRenderingAttachmentFlagBitsKHR;
typedef int VkResolveImageFlagBitsKHR;
typedef int VkDeviceAddressBindingFlagBitsEXT;
typedef int VkDeviceAddressBindingTypeEXT;
typedef int VkMicromapTypeEXT;
typedef int VkBuildMicromapModeEXT;
typedef int VkCopyMicromapModeEXT;
typedef int VkBuildMicromapFlagBitsEXT;
typedef int VkMicromapCreateFlagBitsEXT;
typedef int VkOpacityMicromapFormatEXT;
typedef int VkOpacityMicromapSpecialIndexEXT;
typedef int VkDeviceFaultVendorBinaryHeaderVersionEXT;
typedef int VkIndirectCommandsLayoutUsageFlagBitsEXT;
typedef int VkIndirectExecutionSetInfoTypeEXT;
typedef int VkIndirectCommandsInputModeFlagBitsEXT;
typedef int VkFrameBoundaryFlagBitsEXT;
typedef int VkMemoryDecompressionMethodFlagBitsEXT;
typedef int VkMemoryDecompressionMethodFlagBitsNV;
typedef int VkDepthBiasRepresentationEXT;
typedef int VkDirectDriverLoadingModeLUNARG;
typedef int VkPipelineCreateFlagBits2;
typedef int VkPipelineCreateFlagBits2KHR;
typedef int VkBufferUsageFlagBits2;
typedef int VkBufferUsageFlagBits2KHR;
typedef int VkPartitionedAccelerationStructureOpTypeNV;
typedef int VkPartitionedAccelerationStructureInstanceFlagBitsNV;
typedef int VkAntiLagModeAMD;
typedef int VkAntiLagStageAMD;
typedef int VkDisplacementMicromapFormatNV;
typedef int VkShaderCreateFlagBitsEXT;
typedef int VkShaderCodeTypeEXT;
typedef int VkScopeKHR;
typedef int VkComponentTypeKHR;
typedef int VkScopeNV;
typedef int VkComponentTypeNV;
typedef int VkCubicFilterWeightsQCOM;
typedef int VkBlockMatchWindowCompareModeQCOM;
typedef int VkLayeredDriverUnderlyingApiMSFT;
typedef int VkPhysicalDeviceLayeredApiKHR;
typedef int VkCompressedTriangleFormatAMDX;
typedef int VkDepthClampModeEXT;
typedef int VkTileShadingRenderPassFlagBitsQCOM;
typedef int VkCooperativeVectorMatrixLayoutNV;
typedef int VkAddressCopyFlagBitsKHR;
typedef int VkTensorCreateFlagBitsARM;
typedef int VkTensorUsageFlagBitsARM;
typedef int VkTensorTilingARM;
typedef int VkTensorViewCreateFlagBitsARM;
typedef int VkDataGraphPipelineSessionCreateFlagBitsARM;
typedef int VkDataGraphPipelinePropertyARM;
typedef int VkDataGraphPipelineSessionBindPointARM;
typedef int VkDataGraphPipelineSessionBindPointTypeARM;
typedef int VkDataGraphPipelineDispatchFlagBitsARM;
typedef int VkPhysicalDeviceDataGraphProcessingEngineTypeARM;
typedef int VkPhysicalDeviceDataGraphOperationTypeARM;
typedef int VkDataGraphModelCacheTypeQCOM;
typedef int VkVideoEncodeRgbModelConversionFlagBitsVALVE;
typedef int VkVideoEncodeRgbRangeCompressionFlagBitsVALVE;
typedef int VkVideoEncodeRgbChromaOffsetFlagBitsVALVE;
typedef int VkDescriptorMappingSourceEXT;
typedef int VkSpirvResourceTypeFlagBitsEXT;
typedef int VkColorSpaceKHR;
typedef int VkCompositeAlphaFlagBitsKHR;
typedef int VkDisplayPlaneAlphaFlagBitsKHR;
typedef int VkPresentModeKHR;
typedef int VkSurfaceTransformFlagBitsKHR;
typedef int VkDisplaySurfaceStereoTypeNV;
typedef int VkDebugReportFlagBitsEXT;
typedef int VkDebugReportObjectTypeEXT;
typedef int VkDeviceMemoryReportEventTypeEXT;
typedef int VkRasterizationOrderAMD;
typedef int VkExternalMemoryHandleTypeFlagBitsNV;
typedef int VkExternalMemoryFeatureFlagBitsNV;
typedef int VkValidationCheckEXT;
typedef int VkValidationFeatureEnableEXT;
typedef int VkValidationFeatureDisableEXT;
typedef int VkExternalMemoryHandleTypeFlagBits;
typedef int VkExternalMemoryHandleTypeFlagBitsKHR;
typedef int VkExternalMemoryFeatureFlagBits;
typedef int VkExternalMemoryFeatureFlagBitsKHR;
typedef int VkExternalSemaphoreHandleTypeFlagBits;
typedef int VkExternalSemaphoreHandleTypeFlagBitsKHR;
typedef int VkExternalSemaphoreFeatureFlagBits;
typedef int VkExternalSemaphoreFeatureFlagBitsKHR;
typedef int VkSemaphoreImportFlagBits;
typedef int VkSemaphoreImportFlagBitsKHR;
typedef int VkExternalFenceHandleTypeFlagBits;
typedef int VkExternalFenceHandleTypeFlagBitsKHR;
typedef int VkExternalFenceFeatureFlagBits;
typedef int VkExternalFenceFeatureFlagBitsKHR;
typedef int VkFenceImportFlagBits;
typedef int VkFenceImportFlagBitsKHR;
typedef int VkSurfaceCounterFlagBitsEXT;
typedef int VkDisplayPowerStateEXT;
typedef int VkDeviceEventTypeEXT;
typedef int VkDisplayEventTypeEXT;
typedef int VkPeerMemoryFeatureFlagBits;
typedef int VkPeerMemoryFeatureFlagBitsKHR;
typedef int VkMemoryAllocateFlagBits;
typedef int VkMemoryAllocateFlagBitsKHR;
typedef int VkDeviceGroupPresentModeFlagBitsKHR;
typedef int VkSwapchainCreateFlagBitsKHR;
typedef int VkSubgroupFeatureFlagBits;
typedef int VkTessellationDomainOrigin;
typedef int VkTessellationDomainOriginKHR;
typedef int VkSamplerYcbcrModelConversion;
typedef int VkSamplerYcbcrModelConversionKHR;
typedef int VkSamplerYcbcrRange;
typedef int VkSamplerYcbcrRangeKHR;
typedef int VkChromaLocation;
typedef int VkChromaLocationKHR;
typedef int VkSamplerReductionMode;
typedef int VkSamplerReductionModeEXT;
typedef int VkBlendOverlapEXT;
typedef int VkDebugUtilsMessageSeverityFlagBitsEXT;
typedef int VkDebugUtilsMessageTypeFlagBitsEXT;
typedef int VkFullScreenExclusiveEXT;
typedef int VkShaderFloatControlsIndependence;
typedef int VkShaderFloatControlsIndependenceKHR;
typedef int VkSwapchainImageUsageFlagBitsANDROID;
typedef int VkFragmentShadingRateCombinerOpKHR;
typedef int VkSubmitFlagBits;
typedef int VkSubmitFlagBitsKHR;
typedef int VkGraphicsPipelineLibraryFlagBitsEXT;
typedef int VkOpticalFlowGridSizeFlagBitsNV;
typedef int VkOpticalFlowUsageFlagBitsNV;
typedef int VkOpticalFlowPerformanceLevelNV;
typedef int VkOpticalFlowSessionBindingPointNV;
typedef int VkOpticalFlowSessionCreateFlagBitsNV;
typedef int VkOpticalFlowExecuteFlagBitsNV;
typedef int VkDeviceFaultAddressTypeEXT;
typedef int VkPresentScalingFlagBitsKHR;
typedef int VkPresentScalingFlagBitsEXT;
typedef int VkPresentGravityFlagBitsKHR;
typedef int VkPresentGravityFlagBitsEXT;
typedef int VkLayerSettingTypeEXT;
typedef int VkLatencyMarkerNV;
typedef int VkOutOfBandQueueTypeNV;
typedef int VkPhysicalDeviceSchedulingControlsFlagBitsARM;
typedef int VkMemoryUnmapFlagBits;
typedef int VkMemoryUnmapFlagBitsKHR;
typedef int VkWaylandSurfaceCreateFlagBitsKHR;
typedef int VkPresentStageFlagBitsEXT;
typedef int VkPastPresentationTimingFlagBitsEXT;
typedef int VkPresentTimingInfoFlagBitsEXT;
typedef int VkSwapchainImageUsageFlagBitsOHOS;
typedef int VkPerformanceCounterDescriptionFlagBitsARM;
typedef int VkVendorId;
typedef int VkDriverId;
typedef int VkDriverIdKHR;
typedef int VkShadingRatePaletteEntryNV;
typedef int VkCoarseSampleOrderTypeNV;
typedef int VkPipelineExecutableStatisticFormatKHR;
typedef int VkVideoCodecOperationFlagBitsKHR;
typedef int VkVideoChromaSubsamplingFlagBitsKHR;
typedef int VkVideoComponentBitDepthFlagBitsKHR;
typedef int VkVideoCapabilityFlagBitsKHR;
typedef int VkVideoSessionCreateFlagBitsKHR;
typedef int VkVideoSessionParametersCreateFlagBitsKHR;
typedef int VkVideoCodingControlFlagBitsKHR;
typedef int VkQueryResultStatusKHR;
typedef int VkVideoDecodeUsageFlagBitsKHR;
typedef int VkVideoDecodeCapabilityFlagBitsKHR;
typedef int VkVideoDecodeH264PictureLayoutFlagBitsKHR;
typedef int VkVideoEncodeFlagBitsKHR;
typedef int VkVideoEncodeUsageFlagBitsKHR;
typedef int VkVideoEncodeContentFlagBitsKHR;
typedef int VkVideoEncodeTuningModeKHR;
typedef int VkVideoEncodeCapabilityFlagBitsKHR;
typedef int VkVideoEncodeFeedbackFlagBitsKHR;
typedef int VkVideoEncodeRateControlModeFlagBitsKHR;
typedef int VkVideoEncodeIntraRefreshModeFlagBitsKHR;
typedef int VkVideoEncodeH264CapabilityFlagBitsKHR;
typedef int VkVideoEncodeH264StdFlagBitsKHR;
typedef int VkVideoEncodeH264RateControlFlagBitsKHR;
typedef int VkVideoEncodeH265CapabilityFlagBitsKHR;
typedef int VkVideoEncodeH265StdFlagBitsKHR;
typedef int VkVideoEncodeH265RateControlFlagBitsKHR;
typedef int VkVideoEncodeH265CtbSizeFlagBitsKHR;
typedef int VkVideoEncodeH265TransformBlockSizeFlagBitsKHR;
typedef int VkVideoEncodeAV1CapabilityFlagBitsKHR;
typedef int VkVideoEncodeAV1StdFlagBitsKHR;
typedef int VkVideoEncodeAV1RateControlFlagBitsKHR;
typedef int VkVideoEncodeAV1SuperblockSizeFlagBitsKHR;
typedef int VkVideoEncodeAV1PredictionModeKHR;
typedef int VkVideoEncodeAV1RateControlGroupKHR;
typedef int VkAccessFlagBits3KHR;
typedef int VkDefaultVertexAttributeValueKHR;
typedef int VkAccelerationStructureMotionInstanceTypeNV;
typedef void VkRemoteAddressNV;

// --- Structs (Auto-Sorted) ---
typedef struct VkSpecializationMapEntry {
    uint32_t constantID;
    uint32_t offset;
    size_t size;
} VkSpecializationMapEntry;
typedef struct VkSpecializationInfo {
    uint32_t mapEntryCount;
    const VkSpecializationMapEntry* pMapEntries;
    size_t dataSize;
    const void* pData;
} VkSpecializationInfo;
typedef struct VkPipelineShaderStageCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineShaderStageCreateFlags flags;
    VkShaderStageFlagBits stage;
    VkShaderModule module;
    const char* pName;
    const VkSpecializationInfo* pSpecializationInfo;
} VkPipelineShaderStageCreateInfo;
typedef struct VkMemoryRequirements {
    VkDeviceSize size;
    VkDeviceSize alignment;
    uint32_t memoryTypeBits;
} VkMemoryRequirements;
typedef struct VkVertexInputBindingDescription {
    uint32_t binding;
    uint32_t stride;
    VkVertexInputRate inputRate;
} VkVertexInputBindingDescription;
typedef struct VkVertexInputAttributeDescription {
    uint32_t location;
    uint32_t binding;
    VkFormat format;
    uint32_t offset;
} VkVertexInputAttributeDescription;
typedef struct VkPipelineVertexInputStateCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineVertexInputStateCreateFlags flags;
    uint32_t vertexBindingDescriptionCount;
    const VkVertexInputBindingDescription* pVertexBindingDescriptions;
    uint32_t vertexAttributeDescriptionCount;
    const VkVertexInputAttributeDescription* pVertexAttributeDescriptions;
} VkPipelineVertexInputStateCreateInfo;
typedef struct VkClearDepthStencilValue {
    float depth;
    uint32_t stencil;
} VkClearDepthStencilValue;
typedef union VkClearColorValue {
    float float32[4];
    int32_t int32[4];
    uint32_t uint32[4];
} VkClearColorValue;
typedef union VkClearValue {
    VkClearColorValue color;
    VkClearDepthStencilValue depthStencil;
} VkClearValue;
typedef struct VkDescriptorSetLayoutBinding {
    uint32_t binding;
    VkDescriptorType descriptorType;
    uint32_t descriptorCount;
    VkShaderStageFlags stageFlags;
    const VkSampler* pImmutableSamplers;
} VkDescriptorSetLayoutBinding;
typedef struct VkDescriptorSetLayoutCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkDescriptorSetLayoutCreateFlags flags;
    uint32_t bindingCount;
    const VkDescriptorSetLayoutBinding* pBindings;
} VkDescriptorSetLayoutCreateInfo;
typedef struct VkCommandBufferInheritanceInfo {
    VkStructureType sType;
    const void* pNext;
    VkRenderPass renderPass;
    uint32_t subpass;
    VkFramebuffer framebuffer;
    VkBool32 occlusionQueryEnable;
    VkQueryControlFlags queryFlags;
    VkQueryPipelineStatisticFlags pipelineStatistics;
} VkCommandBufferInheritanceInfo;
typedef struct VkCommandBufferBeginInfo {
    VkStructureType sType;
    const void* pNext;
    VkCommandBufferUsageFlags flags;
    const VkCommandBufferInheritanceInfo* pInheritanceInfo;
} VkCommandBufferBeginInfo;
typedef struct VkDescriptorBufferInfo {
    VkBuffer buffer;
    VkDeviceSize offset;
    VkDeviceSize range;
} VkDescriptorBufferInfo;
typedef struct VkPhysicalDeviceFeatures {
    VkBool32 robustBufferAccess;
    VkBool32 fullDrawIndexUint32;
    VkBool32 imageCubeArray;
    VkBool32 independentBlend;
    VkBool32 geometryShader;
    VkBool32 tessellationShader;
    VkBool32 sampleRateShading;
    VkBool32 dualSrcBlend;
    VkBool32 logicOp;
    VkBool32 multiDrawIndirect;
    VkBool32 drawIndirectFirstInstance;
    VkBool32 depthClamp;
    VkBool32 depthBiasClamp;
    VkBool32 fillModeNonSolid;
    VkBool32 depthBounds;
    VkBool32 wideLines;
    VkBool32 largePoints;
    VkBool32 alphaToOne;
    VkBool32 multiViewport;
    VkBool32 samplerAnisotropy;
    VkBool32 textureCompressionETC2;
    VkBool32 textureCompressionASTC_LDR;
    VkBool32 textureCompressionBC;
    VkBool32 occlusionQueryPrecise;
    VkBool32 pipelineStatisticsQuery;
    VkBool32 vertexPipelineStoresAndAtomics;
    VkBool32 fragmentStoresAndAtomics;
    VkBool32 shaderTessellationAndGeometryPointSize;
    VkBool32 shaderImageGatherExtended;
    VkBool32 shaderStorageImageExtendedFormats;
    VkBool32 shaderStorageImageMultisample;
    VkBool32 shaderStorageImageReadWithoutFormat;
    VkBool32 shaderStorageImageWriteWithoutFormat;
    VkBool32 shaderUniformBufferArrayDynamicIndexing;
    VkBool32 shaderSampledImageArrayDynamicIndexing;
    VkBool32 shaderStorageBufferArrayDynamicIndexing;
    VkBool32 shaderStorageImageArrayDynamicIndexing;
    VkBool32 shaderClipDistance;
    VkBool32 shaderCullDistance;
    VkBool32 shaderFloat64;
    VkBool32 shaderInt64;
    VkBool32 shaderInt16;
    VkBool32 shaderResourceResidency;
    VkBool32 shaderResourceMinLod;
    VkBool32 sparseBinding;
    VkBool32 sparseResidencyBuffer;
    VkBool32 sparseResidencyImage2D;
    VkBool32 sparseResidencyImage3D;
    VkBool32 sparseResidency2Samples;
    VkBool32 sparseResidency4Samples;
    VkBool32 sparseResidency8Samples;
    VkBool32 sparseResidency16Samples;
    VkBool32 sparseResidencyAliased;
    VkBool32 variableMultisampleRate;
    VkBool32 inheritedQueries;
} VkPhysicalDeviceFeatures;
typedef struct VkPipelineInputAssemblyStateCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineInputAssemblyStateCreateFlags flags;
    VkPrimitiveTopology topology;
    VkBool32 primitiveRestartEnable;
} VkPipelineInputAssemblyStateCreateInfo;
typedef struct VkPipelineRasterizationStateCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineRasterizationStateCreateFlags flags;
    VkBool32 depthClampEnable;
    VkBool32 rasterizerDiscardEnable;
    VkPolygonMode polygonMode;
    VkCullModeFlags cullMode;
    VkFrontFace frontFace;
    VkBool32 depthBiasEnable;
    float depthBiasConstantFactor;
    float depthBiasClamp;
    float depthBiasSlopeFactor;
    float lineWidth;
} VkPipelineRasterizationStateCreateInfo;
typedef struct VkPipelineColorBlendAttachmentState {
    VkBool32 blendEnable;
    VkBlendFactor srcColorBlendFactor;
    VkBlendFactor dstColorBlendFactor;
    VkBlendOp colorBlendOp;
    VkBlendFactor srcAlphaBlendFactor;
    VkBlendFactor dstAlphaBlendFactor;
    VkBlendOp alphaBlendOp;
    VkColorComponentFlags colorWriteMask;
} VkPipelineColorBlendAttachmentState;
typedef struct VkDescriptorPoolSize {
    VkDescriptorType type;
    uint32_t descriptorCount;
} VkDescriptorPoolSize;
typedef struct VkDescriptorPoolCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkDescriptorPoolCreateFlags flags;
    uint32_t maxSets;
    uint32_t poolSizeCount;
    const VkDescriptorPoolSize* pPoolSizes;
} VkDescriptorPoolCreateInfo;
typedef struct VkPipelineMultisampleStateCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineMultisampleStateCreateFlags flags;
    VkSampleCountFlagBits rasterizationSamples;
    VkBool32 sampleShadingEnable;
    float minSampleShading;
    const VkSampleMask* pSampleMask;
    VkBool32 alphaToCoverageEnable;
    VkBool32 alphaToOneEnable;
} VkPipelineMultisampleStateCreateInfo;
typedef struct VkPipelineColorBlendStateCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineColorBlendStateCreateFlags flags;
    VkBool32 logicOpEnable;
    VkLogicOp logicOp;
    uint32_t attachmentCount;
    const VkPipelineColorBlendAttachmentState* pAttachments;
    float blendConstants[4];
} VkPipelineColorBlendStateCreateInfo;
typedef struct VkPipelineDynamicStateCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineDynamicStateCreateFlags flags;
    uint32_t dynamicStateCount;
    const VkDynamicState* pDynamicStates;
} VkPipelineDynamicStateCreateInfo;
typedef struct VkStencilOpState {
    VkStencilOp failOp;
    VkStencilOp passOp;
    VkStencilOp depthFailOp;
    VkCompareOp compareOp;
    uint32_t compareMask;
    uint32_t writeMask;
    uint32_t reference;
} VkStencilOpState;
typedef struct VkPipelineDepthStencilStateCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineDepthStencilStateCreateFlags flags;
    VkBool32 depthTestEnable;
    VkBool32 depthWriteEnable;
    VkCompareOp depthCompareOp;
    VkBool32 depthBoundsTestEnable;
    VkBool32 stencilTestEnable;
    VkStencilOpState front;
    VkStencilOpState back;
    float minDepthBounds;
    float maxDepthBounds;
} VkPipelineDepthStencilStateCreateInfo;
typedef struct VkPipelineTessellationStateCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineTessellationStateCreateFlags flags;
    uint32_t patchControlPoints;
} VkPipelineTessellationStateCreateInfo;
typedef struct VkOffset2D {
    int32_t x;
    int32_t y;
} VkOffset2D;
typedef struct VkExtent2D {
    uint32_t width;
    uint32_t height;
} VkExtent2D;
typedef struct VkRect2D {
    VkOffset2D offset;
    VkExtent2D extent;
} VkRect2D;
typedef struct VkViewport {
    float x;
    float y;
    float width;
    float height;
    float minDepth;
    float maxDepth;
} VkViewport;
typedef struct VkPipelineViewportStateCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineViewportStateCreateFlags flags;
    uint32_t viewportCount;
    const VkViewport* pViewports;
    uint32_t scissorCount;
    const VkRect2D* pScissors;
} VkPipelineViewportStateCreateInfo;
typedef struct VkGraphicsPipelineCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineCreateFlags flags;
    uint32_t stageCount;
    const VkPipelineShaderStageCreateInfo* pStages;
    const VkPipelineVertexInputStateCreateInfo* pVertexInputState;
    const VkPipelineInputAssemblyStateCreateInfo* pInputAssemblyState;
    const VkPipelineTessellationStateCreateInfo* pTessellationState;
    const VkPipelineViewportStateCreateInfo* pViewportState;
    const VkPipelineRasterizationStateCreateInfo* pRasterizationState;
    const VkPipelineMultisampleStateCreateInfo* pMultisampleState;
    const VkPipelineDepthStencilStateCreateInfo* pDepthStencilState;
    const VkPipelineColorBlendStateCreateInfo* pColorBlendState;
    const VkPipelineDynamicStateCreateInfo* pDynamicState;
    VkPipelineLayout layout;
    VkRenderPass renderPass;
    uint32_t subpass;
    VkPipeline basePipelineHandle;
    int32_t basePipelineIndex;
} VkGraphicsPipelineCreateInfo;
typedef struct VkDescriptorSetAllocateInfo {
    VkStructureType sType;
    const void* pNext;
    VkDescriptorPool descriptorPool;
    uint32_t descriptorSetCount;
    const VkDescriptorSetLayout* pSetLayouts;
} VkDescriptorSetAllocateInfo;
typedef struct VkRenderingAttachmentInfo {
    VkStructureType sType;
    const void* pNext;
    VkImageView imageView;
    VkImageLayout imageLayout;
    VkResolveModeFlagBits resolveMode;
    VkImageView resolveImageView;
    VkImageLayout resolveImageLayout;
    VkAttachmentLoadOp loadOp;
    VkAttachmentStoreOp storeOp;
    VkClearValue clearValue;
} VkRenderingAttachmentInfo;
typedef struct VkSwapchainCreateInfoKHR {
    VkStructureType sType;
    const void* pNext;
    VkSwapchainCreateFlagsKHR flags;
    VkSurfaceKHR surface;
    uint32_t minImageCount;
    VkFormat imageFormat;
    VkColorSpaceKHR imageColorSpace;
    VkExtent2D imageExtent;
    uint32_t imageArrayLayers;
    VkImageUsageFlags imageUsage;
    VkSharingMode imageSharingMode;
    uint32_t queueFamilyIndexCount;
    const uint32_t* pQueueFamilyIndices;
    VkSurfaceTransformFlagBitsKHR preTransform;
    VkCompositeAlphaFlagBitsKHR compositeAlpha;
    VkPresentModeKHR presentMode;
    VkBool32 clipped;
    VkSwapchainKHR oldSwapchain;
} VkSwapchainCreateInfoKHR;
typedef struct VkAllocationCallbacks {
    void* pUserData;
    PFN_vkAllocationFunction pfnAllocation;
    PFN_vkReallocationFunction pfnReallocation;
    PFN_vkFreeFunction pfnFree;
    PFN_vkInternalAllocationNotification pfnInternalAllocation;
    PFN_vkInternalFreeNotification pfnInternalFree;
} VkAllocationCallbacks;
typedef struct VkPushConstantRange {
    VkShaderStageFlags stageFlags;
    uint32_t offset;
    uint32_t size;
} VkPushConstantRange;
typedef struct VkSubmitInfo {
    VkStructureType sType;
    const void* pNext;
    uint32_t waitSemaphoreCount;
    const VkSemaphore* pWaitSemaphores;
    const VkPipelineStageFlags* pWaitDstStageMask;
    uint32_t commandBufferCount;
    const VkCommandBuffer* pCommandBuffers;
    uint32_t signalSemaphoreCount;
    const VkSemaphore* pSignalSemaphores;
} VkSubmitInfo;
typedef struct VkMemoryType {
    VkMemoryPropertyFlags propertyFlags;
    uint32_t heapIndex;
} VkMemoryType;
typedef struct VkMemoryHeap {
    VkDeviceSize size;
    VkMemoryHeapFlags flags;
} VkMemoryHeap;
typedef struct VkPhysicalDeviceMemoryProperties {
    uint32_t memoryTypeCount;
    VkMemoryType memoryTypes[32];
    uint32_t memoryHeapCount;
    VkMemoryHeap memoryHeaps[16];
} VkPhysicalDeviceMemoryProperties;
typedef struct VkComputePipelineCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineCreateFlags flags;
    VkPipelineShaderStageCreateInfo stage;
    VkPipelineLayout layout;
    VkPipeline basePipelineHandle;
    int32_t basePipelineIndex;
} VkComputePipelineCreateInfo;
typedef struct VkCopyDescriptorSet {
    VkStructureType sType;
    const void* pNext;
    VkDescriptorSet srcSet;
    uint32_t srcBinding;
    uint32_t srcArrayElement;
    VkDescriptorSet dstSet;
    uint32_t dstBinding;
    uint32_t dstArrayElement;
    uint32_t descriptorCount;
} VkCopyDescriptorSet;
typedef struct VkBufferMemoryBarrier {
    VkStructureType sType;
    const void* pNext;
    VkAccessFlags srcAccessMask;
    VkAccessFlags dstAccessMask;
    uint32_t srcQueueFamilyIndex;
    uint32_t dstQueueFamilyIndex;
    VkBuffer buffer;
    VkDeviceSize offset;
    VkDeviceSize size;
} VkBufferMemoryBarrier;
typedef struct VkCommandPoolCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkCommandPoolCreateFlags flags;
    uint32_t queueFamilyIndex;
} VkCommandPoolCreateInfo;
typedef struct VkCommandBufferAllocateInfo {
    VkStructureType sType;
    const void* pNext;
    VkCommandPool commandPool;
    VkCommandBufferLevel level;
    uint32_t commandBufferCount;
} VkCommandBufferAllocateInfo;
typedef struct VkDeviceQueueCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkDeviceQueueCreateFlags flags;
    uint32_t queueFamilyIndex;
    uint32_t queueCount;
    const float* pQueuePriorities;
} VkDeviceQueueCreateInfo;
typedef struct VkPresentInfoKHR {
    VkStructureType sType;
    const void* pNext;
    uint32_t waitSemaphoreCount;
    const VkSemaphore* pWaitSemaphores;
    uint32_t swapchainCount;
    const VkSwapchainKHR* pSwapchains;
    const uint32_t* pImageIndices;
    VkResult* pResults;
} VkPresentInfoKHR;
typedef struct VkPipelineLayoutCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkPipelineLayoutCreateFlags flags;
    uint32_t setLayoutCount;
    const VkDescriptorSetLayout* pSetLayouts;
    uint32_t pushConstantRangeCount;
    const VkPushConstantRange* pPushConstantRanges;
} VkPipelineLayoutCreateInfo;
typedef struct VkRenderingInfo {
    VkStructureType sType;
    const void* pNext;
    VkRenderingFlags flags;
    VkRect2D renderArea;
    uint32_t layerCount;
    uint32_t viewMask;
    uint32_t colorAttachmentCount;
    const VkRenderingAttachmentInfo* pColorAttachments;
    const VkRenderingAttachmentInfo* pDepthAttachment;
    const VkRenderingAttachmentInfo* pStencilAttachment;
} VkRenderingInfo;
typedef struct VkApplicationInfo {
    VkStructureType sType;
    const void* pNext;
    const char* pApplicationName;
    uint32_t applicationVersion;
    const char* pEngineName;
    uint32_t engineVersion;
    uint32_t apiVersion;
} VkApplicationInfo;
typedef struct VkInstanceCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkInstanceCreateFlags flags;
    const VkApplicationInfo* pApplicationInfo;
    uint32_t enabledLayerCount;
    const char* const* ppEnabledLayerNames;
    uint32_t enabledExtensionCount;
    const char* const* ppEnabledExtensionNames;
} VkInstanceCreateInfo;
typedef struct VkSemaphoreCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkSemaphoreCreateFlags flags;
} VkSemaphoreCreateInfo;
typedef struct VkMemoryAllocateInfo {
    VkStructureType sType;
    const void* pNext;
    VkDeviceSize allocationSize;
    uint32_t memoryTypeIndex;
} VkMemoryAllocateInfo;
typedef struct VkImageSubresourceRange {
    VkImageAspectFlags aspectMask;
    uint32_t baseMipLevel;
    uint32_t levelCount;
    uint32_t baseArrayLayer;
    uint32_t layerCount;
} VkImageSubresourceRange;
typedef struct VkImageMemoryBarrier {
    VkStructureType sType;
    const void* pNext;
    VkAccessFlags srcAccessMask;
    VkAccessFlags dstAccessMask;
    VkImageLayout oldLayout;
    VkImageLayout newLayout;
    uint32_t srcQueueFamilyIndex;
    uint32_t dstQueueFamilyIndex;
    VkImage image;
    VkImageSubresourceRange subresourceRange;
} VkImageMemoryBarrier;
typedef struct VkDescriptorImageInfo {
    VkSampler sampler;
    VkImageView imageView;
    VkImageLayout imageLayout;
} VkDescriptorImageInfo;
typedef struct VkWriteDescriptorSet {
    VkStructureType sType;
    const void* pNext;
    VkDescriptorSet dstSet;
    uint32_t dstBinding;
    uint32_t dstArrayElement;
    uint32_t descriptorCount;
    VkDescriptorType descriptorType;
    const VkDescriptorImageInfo* pImageInfo;
    const VkDescriptorBufferInfo* pBufferInfo;
    const VkBufferView* pTexelBufferView;
} VkWriteDescriptorSet;
typedef struct VkMemoryBarrier {
    VkStructureType sType;
    const void* pNext;
    VkAccessFlags srcAccessMask;
    VkAccessFlags dstAccessMask;
} VkMemoryBarrier;
typedef struct VkDeviceCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkDeviceCreateFlags flags;
    uint32_t queueCreateInfoCount;
    const VkDeviceQueueCreateInfo* pQueueCreateInfos;
    uint32_t enabledLayerCount;
    const char* const* ppEnabledLayerNames;
    uint32_t enabledExtensionCount;
    const char* const* ppEnabledExtensionNames;
    const VkPhysicalDeviceFeatures* pEnabledFeatures;
} VkDeviceCreateInfo;
typedef struct VkBufferCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkBufferCreateFlags flags;
    VkDeviceSize size;
    VkBufferUsageFlags usage;
    VkSharingMode sharingMode;
    uint32_t queueFamilyIndexCount;
    const uint32_t* pQueueFamilyIndices;
} VkBufferCreateInfo;
typedef struct VkShaderModuleCreateInfo {
    VkStructureType sType;
    const void* pNext;
    VkShaderModuleCreateFlags flags;
    size_t codeSize;
    const uint32_t* pCode;
} VkShaderModuleCreateInfo;

// --- Functions ---
VkResult vkCreateInstance(const VkInstanceCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkInstance* pInstance);
void vkDestroyInstance(VkInstance instance, const VkAllocationCallbacks* pAllocator);
VkResult vkEnumeratePhysicalDevices(VkInstance instance, uint32_t* pPhysicalDeviceCount, VkPhysicalDevice* pPhysicalDevices);
void vkGetPhysicalDeviceMemoryProperties(VkPhysicalDevice physicalDevice, VkPhysicalDeviceMemoryProperties* pMemoryProperties);
VkResult vkCreateDevice(VkPhysicalDevice physicalDevice, const VkDeviceCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkDevice* pDevice);
void vkDestroyDevice(VkDevice device, const VkAllocationCallbacks* pAllocator);
VkResult vkQueueSubmit(VkQueue queue, uint32_t submitCount, const VkSubmitInfo* pSubmits, VkFence fence);
VkResult vkQueueWaitIdle(VkQueue queue);
VkResult vkDeviceWaitIdle(VkDevice device);
VkResult vkAllocateMemory(VkDevice device, const VkMemoryAllocateInfo* pAllocateInfo, const VkAllocationCallbacks* pAllocator, VkDeviceMemory* pMemory);
void vkFreeMemory(VkDevice device, VkDeviceMemory memory, const VkAllocationCallbacks* pAllocator);
VkResult vkMapMemory(VkDevice device, VkDeviceMemory memory, VkDeviceSize offset, VkDeviceSize size, VkMemoryMapFlags flags, void** ppData);
void vkUnmapMemory(VkDevice device, VkDeviceMemory memory);
void vkGetBufferMemoryRequirements(VkDevice device, VkBuffer buffer, VkMemoryRequirements* pMemoryRequirements);
VkResult vkBindBufferMemory(VkDevice device, VkBuffer buffer, VkDeviceMemory memory, VkDeviceSize memoryOffset);
VkResult vkCreateSemaphore(VkDevice device, const VkSemaphoreCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkSemaphore* pSemaphore);
void vkDestroySemaphore(VkDevice device, VkSemaphore semaphore, const VkAllocationCallbacks* pAllocator);
VkResult vkCreateBuffer(VkDevice device, const VkBufferCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkBuffer* pBuffer);
void vkDestroyBuffer(VkDevice device, VkBuffer buffer, const VkAllocationCallbacks* pAllocator);
VkResult vkCreateShaderModule(VkDevice device, const VkShaderModuleCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkShaderModule* pShaderModule);
void vkDestroyShaderModule(VkDevice device, VkShaderModule shaderModule, const VkAllocationCallbacks* pAllocator);
VkResult vkCreateGraphicsPipelines(VkDevice device, VkPipelineCache pipelineCache, uint32_t createInfoCount, const VkGraphicsPipelineCreateInfo* pCreateInfos, const VkAllocationCallbacks* pAllocator, VkPipeline* pPipelines);
VkResult vkCreateComputePipelines(VkDevice device, VkPipelineCache pipelineCache, uint32_t createInfoCount, const VkComputePipelineCreateInfo* pCreateInfos, const VkAllocationCallbacks* pAllocator, VkPipeline* pPipelines);
void vkDestroyPipeline(VkDevice device, VkPipeline pipeline, const VkAllocationCallbacks* pAllocator);
VkResult vkCreatePipelineLayout(VkDevice device, const VkPipelineLayoutCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkPipelineLayout* pPipelineLayout);
void vkDestroyPipelineLayout(VkDevice device, VkPipelineLayout pipelineLayout, const VkAllocationCallbacks* pAllocator);
VkResult vkCreateDescriptorSetLayout(VkDevice device, const VkDescriptorSetLayoutCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkDescriptorSetLayout* pSetLayout);
void vkDestroyDescriptorSetLayout(VkDevice device, VkDescriptorSetLayout descriptorSetLayout, const VkAllocationCallbacks* pAllocator);
VkResult vkCreateDescriptorPool(VkDevice device, const VkDescriptorPoolCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkDescriptorPool* pDescriptorPool);
void vkDestroyDescriptorPool(VkDevice device, VkDescriptorPool descriptorPool, const VkAllocationCallbacks* pAllocator);
VkResult vkAllocateDescriptorSets(VkDevice device, const VkDescriptorSetAllocateInfo* pAllocateInfo, VkDescriptorSet* pDescriptorSets);
void vkUpdateDescriptorSets(VkDevice device, uint32_t descriptorWriteCount, const VkWriteDescriptorSet* pDescriptorWrites, uint32_t descriptorCopyCount, const VkCopyDescriptorSet* pDescriptorCopies);
VkResult vkCreateCommandPool(VkDevice device, const VkCommandPoolCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkCommandPool* pCommandPool);
void vkDestroyCommandPool(VkDevice device, VkCommandPool commandPool, const VkAllocationCallbacks* pAllocator);
VkResult vkAllocateCommandBuffers(VkDevice device, const VkCommandBufferAllocateInfo* pAllocateInfo, VkCommandBuffer* pCommandBuffers);
VkResult vkBeginCommandBuffer(VkCommandBuffer commandBuffer, const VkCommandBufferBeginInfo* pBeginInfo);
VkResult vkEndCommandBuffer(VkCommandBuffer commandBuffer);
VkResult vkResetCommandBuffer(VkCommandBuffer commandBuffer, VkCommandBufferResetFlags flags);
void vkCmdBindPipeline(VkCommandBuffer commandBuffer, VkPipelineBindPoint pipelineBindPoint, VkPipeline pipeline);
void vkCmdBindDescriptorSets(VkCommandBuffer commandBuffer, VkPipelineBindPoint pipelineBindPoint, VkPipelineLayout layout, uint32_t firstSet, uint32_t descriptorSetCount, const VkDescriptorSet* pDescriptorSets, uint32_t dynamicOffsetCount, const uint32_t* pDynamicOffsets);
void vkCmdDraw(VkCommandBuffer commandBuffer, uint32_t vertexCount, uint32_t instanceCount, uint32_t firstVertex, uint32_t firstInstance);
void vkCmdDispatch(VkCommandBuffer commandBuffer, uint32_t groupCountX, uint32_t groupCountY, uint32_t groupCountZ);
void vkCmdPipelineBarrier(VkCommandBuffer commandBuffer, VkPipelineStageFlags srcStageMask, VkPipelineStageFlags dstStageMask, VkDependencyFlags dependencyFlags, uint32_t memoryBarrierCount, const VkMemoryBarrier* pMemoryBarriers, uint32_t bufferMemoryBarrierCount, const VkBufferMemoryBarrier* pBufferMemoryBarriers, uint32_t imageMemoryBarrierCount, const VkImageMemoryBarrier* pImageMemoryBarriers);
void vkCmdPushConstants(VkCommandBuffer commandBuffer, VkPipelineLayout layout, VkShaderStageFlags stageFlags, uint32_t offset, uint32_t size, const void* pValues);
VkResult vkCreateSwapchainKHR(VkDevice device, const VkSwapchainCreateInfoKHR* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkSwapchainKHR* pSwapchain);
void vkDestroySwapchainKHR(VkDevice device, VkSwapchainKHR swapchain, const VkAllocationCallbacks* pAllocator);
VkResult vkAcquireNextImageKHR(VkDevice device, VkSwapchainKHR swapchain, uint64_t timeout, VkSemaphore semaphore, VkFence fence, uint32_t* pImageIndex);
VkResult vkQueuePresentKHR(VkQueue queue, const VkPresentInfoKHR* pPresentInfo);
void vkCmdBeginRendering(VkCommandBuffer commandBuffer, const VkRenderingInfo* pRenderingInfo);
void vkCmdEndRendering(VkCommandBuffer commandBuffer);
]]
-- =========================================================
-- END OF BOILERPLATE
-- START OF vulkan_core.lua
-- =========================================================

local vk
-- 1. Try Windows/Wine standard (vulkan-1.dll)
local success, lib = pcall(ffi.load, "vulkan-1")

-- 2. Try Linux standard (libvulkan.so)
if not success then
    success, lib = pcall(ffi.load, "vulkan")
end

-- 3. Try Linux strict versioning (libvulkan.so.1)
if not success then
    success, lib = pcall(ffi.load, "libvulkan.so.1")
end

assert(success, "FATAL: Could not load the Vulkan dynamic library! Is the Vulkan runtime installed?\nError: " .. tostring(lib))
vk = lib

local core = {}

function core.init()
    print("[LUA] Initializing Vulkan Core...")

    -- 1. Ask C for the OS Extensions needed for the Window
    local exts_ptr, exts_count = C_Bridge.get_glfw_extensions()
    -- Cast the raw pointer to something the FFI understands
    local glfwExtensions = ffi.cast("const char* const*", exts_ptr)

    -- 2. Build the Application Info
    local appInfo = ffi.new("VkApplicationInfo", {
        sType = 0, -- VK_STRUCTURE_TYPE_APPLICATION_INFO
        pApplicationName = "VibeEngine Cooking Dish",
        apiVersion = 4194304 -- VK_API_VERSION_1_0
    })

    -- 3. Build the Instance Info
    local createInfo = ffi.new("VkInstanceCreateInfo", {
        sType = 1, -- VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO
        pApplicationInfo = appInfo,
        enabledExtensionCount = exts_count,
        ppEnabledExtensionNames = glfwExtensions,
        enabledLayerCount = 0 -- We will add validation layers back later
    })

    -- 4. Create the Instance
    local pInstance = ffi.new("VkInstance[1]")
    local res = vk.vkCreateInstance(createInfo, nil, pInstance)
    assert(res == 0, "FATAL: vkCreateInstance failed!")
    local instance = pInstance[0]
    print("[LUA] Vulkan Instance Created!")

    -- 5. Ask C to create the Window Surface using our new Instance
    -- We cast the pointer to a raw number so C can read it safely without FFI metadata
    local instance_address = tonumber(ffi.cast("uintptr_t", instance))
    local surface = C_Bridge.create_surface(instance_address)
    -- The surface comes back as a number, so we cast it back to a Vulkan handle
    surface = ffi.cast("VkSurfaceKHR", surface)
    print("[LUA] Window Surface Linked!")

    -- 6. Find the GPU
    local pDeviceCount = ffi.new("uint32_t[1]")
    vk.vkEnumeratePhysicalDevices(instance, pDeviceCount, nil)
    local pDevices = ffi.new("VkPhysicalDevice[?]", pDeviceCount[0])
    vk.vkEnumeratePhysicalDevices(instance, pDeviceCount, pDevices)

    local physicalDevice = pDevices[0] -- Just grab the first GPU for now
    print("[LUA] Hardware GPU Selected!")

    return {
        instance = instance,
        physicalDevice = physicalDevice,
        surface = surface
        device = device,         -- ADD THIS! (The Logical Device)
        queue = queue,           -- ADD THIS! (The Command Queue)
        qIndex = qIndex          -- ADD THIS! (The Queue Family Index)
    }
end

return core
