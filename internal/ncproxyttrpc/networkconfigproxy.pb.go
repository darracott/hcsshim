// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.31.0
// 	protoc        v4.23.2
// source: github.com/Microsoft/hcsshim/internal/ncproxyttrpc/networkconfigproxy.proto

package ncproxyttrpc

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type RequestTypeInternal int32

const (
	RequestTypeInternal_Setup    RequestTypeInternal = 0
	RequestTypeInternal_Teardown RequestTypeInternal = 1
)

// Enum value maps for RequestTypeInternal.
var (
	RequestTypeInternal_name = map[int32]string{
		0: "Setup",
		1: "Teardown",
	}
	RequestTypeInternal_value = map[string]int32{
		"Setup":    0,
		"Teardown": 1,
	}
)

func (x RequestTypeInternal) Enum() *RequestTypeInternal {
	p := new(RequestTypeInternal)
	*p = x
	return p
}

func (x RequestTypeInternal) String() string {
	return protoimpl.X.EnumStringOf(x.Descriptor(), protoreflect.EnumNumber(x))
}

func (RequestTypeInternal) Descriptor() protoreflect.EnumDescriptor {
	return file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_enumTypes[0].Descriptor()
}

func (RequestTypeInternal) Type() protoreflect.EnumType {
	return &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_enumTypes[0]
}

func (x RequestTypeInternal) Number() protoreflect.EnumNumber {
	return protoreflect.EnumNumber(x)
}

// Deprecated: Use RequestTypeInternal.Descriptor instead.
func (RequestTypeInternal) EnumDescriptor() ([]byte, []int) {
	return file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescGZIP(), []int{0}
}

type RegisterComputeAgentRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	AgentAddress string `protobuf:"bytes,1,opt,name=agent_address,json=agentAddress,proto3" json:"agent_address,omitempty"`
	ContainerID  string `protobuf:"bytes,2,opt,name=container_id,json=containerId,proto3" json:"container_id,omitempty"`
}

func (x *RegisterComputeAgentRequest) Reset() {
	*x = RegisterComputeAgentRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *RegisterComputeAgentRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*RegisterComputeAgentRequest) ProtoMessage() {}

func (x *RegisterComputeAgentRequest) ProtoReflect() protoreflect.Message {
	mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use RegisterComputeAgentRequest.ProtoReflect.Descriptor instead.
func (*RegisterComputeAgentRequest) Descriptor() ([]byte, []int) {
	return file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescGZIP(), []int{0}
}

func (x *RegisterComputeAgentRequest) GetAgentAddress() string {
	if x != nil {
		return x.AgentAddress
	}
	return ""
}

func (x *RegisterComputeAgentRequest) GetContainerID() string {
	if x != nil {
		return x.ContainerID
	}
	return ""
}

type RegisterComputeAgentResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields
}

func (x *RegisterComputeAgentResponse) Reset() {
	*x = RegisterComputeAgentResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *RegisterComputeAgentResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*RegisterComputeAgentResponse) ProtoMessage() {}

func (x *RegisterComputeAgentResponse) ProtoReflect() protoreflect.Message {
	mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use RegisterComputeAgentResponse.ProtoReflect.Descriptor instead.
func (*RegisterComputeAgentResponse) Descriptor() ([]byte, []int) {
	return file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescGZIP(), []int{1}
}

type UnregisterComputeAgentRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	ContainerID string `protobuf:"bytes,1,opt,name=container_id,json=containerId,proto3" json:"container_id,omitempty"`
}

func (x *UnregisterComputeAgentRequest) Reset() {
	*x = UnregisterComputeAgentRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[2]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *UnregisterComputeAgentRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*UnregisterComputeAgentRequest) ProtoMessage() {}

func (x *UnregisterComputeAgentRequest) ProtoReflect() protoreflect.Message {
	mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[2]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use UnregisterComputeAgentRequest.ProtoReflect.Descriptor instead.
func (*UnregisterComputeAgentRequest) Descriptor() ([]byte, []int) {
	return file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescGZIP(), []int{2}
}

func (x *UnregisterComputeAgentRequest) GetContainerID() string {
	if x != nil {
		return x.ContainerID
	}
	return ""
}

type UnregisterComputeAgentResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields
}

func (x *UnregisterComputeAgentResponse) Reset() {
	*x = UnregisterComputeAgentResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[3]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *UnregisterComputeAgentResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*UnregisterComputeAgentResponse) ProtoMessage() {}

func (x *UnregisterComputeAgentResponse) ProtoReflect() protoreflect.Message {
	mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[3]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use UnregisterComputeAgentResponse.ProtoReflect.Descriptor instead.
func (*UnregisterComputeAgentResponse) Descriptor() ([]byte, []int) {
	return file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescGZIP(), []int{3}
}

type ConfigureNetworkingInternalRequest struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	ContainerID string              `protobuf:"bytes,1,opt,name=container_id,json=containerId,proto3" json:"container_id,omitempty"`
	RequestType RequestTypeInternal `protobuf:"varint,2,opt,name=request_type,json=requestType,proto3,enum=RequestTypeInternal" json:"request_type,omitempty"`
}

func (x *ConfigureNetworkingInternalRequest) Reset() {
	*x = ConfigureNetworkingInternalRequest{}
	if protoimpl.UnsafeEnabled {
		mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[4]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *ConfigureNetworkingInternalRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*ConfigureNetworkingInternalRequest) ProtoMessage() {}

func (x *ConfigureNetworkingInternalRequest) ProtoReflect() protoreflect.Message {
	mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[4]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use ConfigureNetworkingInternalRequest.ProtoReflect.Descriptor instead.
func (*ConfigureNetworkingInternalRequest) Descriptor() ([]byte, []int) {
	return file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescGZIP(), []int{4}
}

func (x *ConfigureNetworkingInternalRequest) GetContainerID() string {
	if x != nil {
		return x.ContainerID
	}
	return ""
}

func (x *ConfigureNetworkingInternalRequest) GetRequestType() RequestTypeInternal {
	if x != nil {
		return x.RequestType
	}
	return RequestTypeInternal_Setup
}

type ConfigureNetworkingInternalResponse struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields
}

func (x *ConfigureNetworkingInternalResponse) Reset() {
	*x = ConfigureNetworkingInternalResponse{}
	if protoimpl.UnsafeEnabled {
		mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[5]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *ConfigureNetworkingInternalResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*ConfigureNetworkingInternalResponse) ProtoMessage() {}

func (x *ConfigureNetworkingInternalResponse) ProtoReflect() protoreflect.Message {
	mi := &file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[5]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use ConfigureNetworkingInternalResponse.ProtoReflect.Descriptor instead.
func (*ConfigureNetworkingInternalResponse) Descriptor() ([]byte, []int) {
	return file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescGZIP(), []int{5}
}

var File_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto protoreflect.FileDescriptor

var file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDesc = []byte{
	0x0a, 0x4b, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x4d, 0x69, 0x63,
	0x72, 0x6f, 0x73, 0x6f, 0x66, 0x74, 0x2f, 0x68, 0x63, 0x73, 0x73, 0x68, 0x69, 0x6d, 0x2f, 0x69,
	0x6e, 0x74, 0x65, 0x72, 0x6e, 0x61, 0x6c, 0x2f, 0x6e, 0x63, 0x70, 0x72, 0x6f, 0x78, 0x79, 0x74,
	0x74, 0x72, 0x70, 0x63, 0x2f, 0x6e, 0x65, 0x74, 0x77, 0x6f, 0x72, 0x6b, 0x63, 0x6f, 0x6e, 0x66,
	0x69, 0x67, 0x70, 0x72, 0x6f, 0x78, 0x79, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x22, 0x65, 0x0a,
	0x1b, 0x52, 0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72, 0x43, 0x6f, 0x6d, 0x70, 0x75, 0x74, 0x65,
	0x41, 0x67, 0x65, 0x6e, 0x74, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x23, 0x0a, 0x0d,
	0x61, 0x67, 0x65, 0x6e, 0x74, 0x5f, 0x61, 0x64, 0x64, 0x72, 0x65, 0x73, 0x73, 0x18, 0x01, 0x20,
	0x01, 0x28, 0x09, 0x52, 0x0c, 0x61, 0x67, 0x65, 0x6e, 0x74, 0x41, 0x64, 0x64, 0x72, 0x65, 0x73,
	0x73, 0x12, 0x21, 0x0a, 0x0c, 0x63, 0x6f, 0x6e, 0x74, 0x61, 0x69, 0x6e, 0x65, 0x72, 0x5f, 0x69,
	0x64, 0x18, 0x02, 0x20, 0x01, 0x28, 0x09, 0x52, 0x0b, 0x63, 0x6f, 0x6e, 0x74, 0x61, 0x69, 0x6e,
	0x65, 0x72, 0x49, 0x64, 0x22, 0x1e, 0x0a, 0x1c, 0x52, 0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72,
	0x43, 0x6f, 0x6d, 0x70, 0x75, 0x74, 0x65, 0x41, 0x67, 0x65, 0x6e, 0x74, 0x52, 0x65, 0x73, 0x70,
	0x6f, 0x6e, 0x73, 0x65, 0x22, 0x42, 0x0a, 0x1d, 0x55, 0x6e, 0x72, 0x65, 0x67, 0x69, 0x73, 0x74,
	0x65, 0x72, 0x43, 0x6f, 0x6d, 0x70, 0x75, 0x74, 0x65, 0x41, 0x67, 0x65, 0x6e, 0x74, 0x52, 0x65,
	0x71, 0x75, 0x65, 0x73, 0x74, 0x12, 0x21, 0x0a, 0x0c, 0x63, 0x6f, 0x6e, 0x74, 0x61, 0x69, 0x6e,
	0x65, 0x72, 0x5f, 0x69, 0x64, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x0b, 0x63, 0x6f, 0x6e,
	0x74, 0x61, 0x69, 0x6e, 0x65, 0x72, 0x49, 0x64, 0x22, 0x20, 0x0a, 0x1e, 0x55, 0x6e, 0x72, 0x65,
	0x67, 0x69, 0x73, 0x74, 0x65, 0x72, 0x43, 0x6f, 0x6d, 0x70, 0x75, 0x74, 0x65, 0x41, 0x67, 0x65,
	0x6e, 0x74, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x80, 0x01, 0x0a, 0x22, 0x43,
	0x6f, 0x6e, 0x66, 0x69, 0x67, 0x75, 0x72, 0x65, 0x4e, 0x65, 0x74, 0x77, 0x6f, 0x72, 0x6b, 0x69,
	0x6e, 0x67, 0x49, 0x6e, 0x74, 0x65, 0x72, 0x6e, 0x61, 0x6c, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73,
	0x74, 0x12, 0x21, 0x0a, 0x0c, 0x63, 0x6f, 0x6e, 0x74, 0x61, 0x69, 0x6e, 0x65, 0x72, 0x5f, 0x69,
	0x64, 0x18, 0x01, 0x20, 0x01, 0x28, 0x09, 0x52, 0x0b, 0x63, 0x6f, 0x6e, 0x74, 0x61, 0x69, 0x6e,
	0x65, 0x72, 0x49, 0x64, 0x12, 0x37, 0x0a, 0x0c, 0x72, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x5f,
	0x74, 0x79, 0x70, 0x65, 0x18, 0x02, 0x20, 0x01, 0x28, 0x0e, 0x32, 0x14, 0x2e, 0x52, 0x65, 0x71,
	0x75, 0x65, 0x73, 0x74, 0x54, 0x79, 0x70, 0x65, 0x49, 0x6e, 0x74, 0x65, 0x72, 0x6e, 0x61, 0x6c,
	0x52, 0x0b, 0x72, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x54, 0x79, 0x70, 0x65, 0x22, 0x25, 0x0a,
	0x23, 0x43, 0x6f, 0x6e, 0x66, 0x69, 0x67, 0x75, 0x72, 0x65, 0x4e, 0x65, 0x74, 0x77, 0x6f, 0x72,
	0x6b, 0x69, 0x6e, 0x67, 0x49, 0x6e, 0x74, 0x65, 0x72, 0x6e, 0x61, 0x6c, 0x52, 0x65, 0x73, 0x70,
	0x6f, 0x6e, 0x73, 0x65, 0x2a, 0x2e, 0x0a, 0x13, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x54,
	0x79, 0x70, 0x65, 0x49, 0x6e, 0x74, 0x65, 0x72, 0x6e, 0x61, 0x6c, 0x12, 0x09, 0x0a, 0x05, 0x53,
	0x65, 0x74, 0x75, 0x70, 0x10, 0x00, 0x12, 0x0c, 0x0a, 0x08, 0x54, 0x65, 0x61, 0x72, 0x64, 0x6f,
	0x77, 0x6e, 0x10, 0x01, 0x32, 0xac, 0x02, 0x0a, 0x12, 0x4e, 0x65, 0x74, 0x77, 0x6f, 0x72, 0x6b,
	0x43, 0x6f, 0x6e, 0x66, 0x69, 0x67, 0x50, 0x72, 0x6f, 0x78, 0x79, 0x12, 0x55, 0x0a, 0x14, 0x52,
	0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72, 0x43, 0x6f, 0x6d, 0x70, 0x75, 0x74, 0x65, 0x41, 0x67,
	0x65, 0x6e, 0x74, 0x12, 0x1c, 0x2e, 0x52, 0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72, 0x43, 0x6f,
	0x6d, 0x70, 0x75, 0x74, 0x65, 0x41, 0x67, 0x65, 0x6e, 0x74, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73,
	0x74, 0x1a, 0x1d, 0x2e, 0x52, 0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72, 0x43, 0x6f, 0x6d, 0x70,
	0x75, 0x74, 0x65, 0x41, 0x67, 0x65, 0x6e, 0x74, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65,
	0x22, 0x00, 0x12, 0x5b, 0x0a, 0x16, 0x55, 0x6e, 0x72, 0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72,
	0x43, 0x6f, 0x6d, 0x70, 0x75, 0x74, 0x65, 0x41, 0x67, 0x65, 0x6e, 0x74, 0x12, 0x1e, 0x2e, 0x55,
	0x6e, 0x72, 0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72, 0x43, 0x6f, 0x6d, 0x70, 0x75, 0x74, 0x65,
	0x41, 0x67, 0x65, 0x6e, 0x74, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x1f, 0x2e, 0x55,
	0x6e, 0x72, 0x65, 0x67, 0x69, 0x73, 0x74, 0x65, 0x72, 0x43, 0x6f, 0x6d, 0x70, 0x75, 0x74, 0x65,
	0x41, 0x67, 0x65, 0x6e, 0x74, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x00, 0x12,
	0x62, 0x0a, 0x13, 0x43, 0x6f, 0x6e, 0x66, 0x69, 0x67, 0x75, 0x72, 0x65, 0x4e, 0x65, 0x74, 0x77,
	0x6f, 0x72, 0x6b, 0x69, 0x6e, 0x67, 0x12, 0x23, 0x2e, 0x43, 0x6f, 0x6e, 0x66, 0x69, 0x67, 0x75,
	0x72, 0x65, 0x4e, 0x65, 0x74, 0x77, 0x6f, 0x72, 0x6b, 0x69, 0x6e, 0x67, 0x49, 0x6e, 0x74, 0x65,
	0x72, 0x6e, 0x61, 0x6c, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x24, 0x2e, 0x43, 0x6f,
	0x6e, 0x66, 0x69, 0x67, 0x75, 0x72, 0x65, 0x4e, 0x65, 0x74, 0x77, 0x6f, 0x72, 0x6b, 0x69, 0x6e,
	0x67, 0x49, 0x6e, 0x74, 0x65, 0x72, 0x6e, 0x61, 0x6c, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73,
	0x65, 0x22, 0x00, 0x42, 0x42, 0x5a, 0x40, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2e, 0x63, 0x6f,
	0x6d, 0x2f, 0x4d, 0x69, 0x63, 0x72, 0x6f, 0x73, 0x6f, 0x66, 0x74, 0x2f, 0x68, 0x63, 0x73, 0x73,
	0x68, 0x69, 0x6d, 0x2f, 0x69, 0x6e, 0x74, 0x65, 0x72, 0x6e, 0x61, 0x6c, 0x2f, 0x6e, 0x63, 0x70,
	0x72, 0x6f, 0x78, 0x79, 0x74, 0x74, 0x72, 0x70, 0x63, 0x2f, 0x3b, 0x6e, 0x63, 0x70, 0x72, 0x6f,
	0x78, 0x79, 0x74, 0x74, 0x72, 0x70, 0x63, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33,
}

var (
	file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescOnce sync.Once
	file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescData = file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDesc
)

func file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescGZIP() []byte {
	file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescOnce.Do(func() {
		file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescData = protoimpl.X.CompressGZIP(file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescData)
	})
	return file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDescData
}

var file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_enumTypes = make([]protoimpl.EnumInfo, 1)
var file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes = make([]protoimpl.MessageInfo, 6)
var file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_goTypes = []interface{}{
	(RequestTypeInternal)(0),                    // 0: RequestTypeInternal
	(*RegisterComputeAgentRequest)(nil),         // 1: RegisterComputeAgentRequest
	(*RegisterComputeAgentResponse)(nil),        // 2: RegisterComputeAgentResponse
	(*UnregisterComputeAgentRequest)(nil),       // 3: UnregisterComputeAgentRequest
	(*UnregisterComputeAgentResponse)(nil),      // 4: UnregisterComputeAgentResponse
	(*ConfigureNetworkingInternalRequest)(nil),  // 5: ConfigureNetworkingInternalRequest
	(*ConfigureNetworkingInternalResponse)(nil), // 6: ConfigureNetworkingInternalResponse
}
var file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_depIdxs = []int32{
	0, // 0: ConfigureNetworkingInternalRequest.request_type:type_name -> RequestTypeInternal
	1, // 1: NetworkConfigProxy.RegisterComputeAgent:input_type -> RegisterComputeAgentRequest
	3, // 2: NetworkConfigProxy.UnregisterComputeAgent:input_type -> UnregisterComputeAgentRequest
	5, // 3: NetworkConfigProxy.ConfigureNetworking:input_type -> ConfigureNetworkingInternalRequest
	2, // 4: NetworkConfigProxy.RegisterComputeAgent:output_type -> RegisterComputeAgentResponse
	4, // 5: NetworkConfigProxy.UnregisterComputeAgent:output_type -> UnregisterComputeAgentResponse
	6, // 6: NetworkConfigProxy.ConfigureNetworking:output_type -> ConfigureNetworkingInternalResponse
	4, // [4:7] is the sub-list for method output_type
	1, // [1:4] is the sub-list for method input_type
	1, // [1:1] is the sub-list for extension type_name
	1, // [1:1] is the sub-list for extension extendee
	0, // [0:1] is the sub-list for field type_name
}

func init() { file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_init() }
func file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_init() {
	if File_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto != nil {
		return
	}
	if !protoimpl.UnsafeEnabled {
		file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[0].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*RegisterComputeAgentRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[1].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*RegisterComputeAgentResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[2].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*UnregisterComputeAgentRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[3].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*UnregisterComputeAgentResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[4].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*ConfigureNetworkingInternalRequest); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes[5].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*ConfigureNetworkingInternalResponse); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDesc,
			NumEnums:      1,
			NumMessages:   6,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_goTypes,
		DependencyIndexes: file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_depIdxs,
		EnumInfos:         file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_enumTypes,
		MessageInfos:      file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_msgTypes,
	}.Build()
	File_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto = out.File
	file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_rawDesc = nil
	file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_goTypes = nil
	file_github_com_Microsoft_hcsshim_internal_ncproxyttrpc_networkconfigproxy_proto_depIdxs = nil
}
