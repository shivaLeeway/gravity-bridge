package types

import (
	"github.com/gogo/protobuf/proto"

	"github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/types/msgservice"
)

// RegisterInterfaces registers the interfaces for the proto stuff
func RegisterInterfaces(registry types.InterfaceRegistry) {
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgSendToEthereum{},
		&MsgCancelSendToEthereum{},
		&MsgRequestBatchTx{},
		&MsgSubmitEthereumEvent{},
		&MsgSubmitEthereumSignature{},
	)

	registry.RegisterInterface(
		"gravity.v1.EthereumEvent",
		(*EthereumEvent)(nil),
		&SendToCosmosEvent{},
		&BatchTxExecutedEvent{},
		&CosmosERC20DeployedEvent{},
		&ContractCallTxExecutedEvent{},
	)

	registry.RegisterInterface(
		"gravity.v1.Confirm",
		(*EthereumSignature)(nil),
		&BatchTxSignature{},
		&ContractCallTxSignature{},
		&UpdateSignerSetTxSignature{},
	)

	msgservice.RegisterMsgServiceDesc(registry, &_Msg_serviceDesc)
}

func PackEvent(event EthereumEvent) (*types.Any, error) {
	msg, ok := event.(proto.Message)
	if !ok {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrPackAny, "cannot proto marshal %T", event)
	}

	anyEvent, err := types.NewAnyWithValue(msg)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrPackAny, err.Error())
	}

	return anyEvent, nil
}

// UnpackEvent unpacks an Any into an EthereumEvent. It returns an error if the
// event can't be unpacked.
func UnpackEvent(any *types.Any) (EthereumEvent, error) {
	if any == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnpackAny, "protobuf Any message cannot be nil")
	}

	event, ok := any.GetCachedValue().(EthereumEvent)
	if !ok {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrUnpackAny, "cannot unpack Any into EthereumEvent %T", any)
	}

	return event, nil
}

// UnpackSignature unpacks an Any into a Confirm interface. It returns an error if the
// confirm can't be unpacked.
func UnpackSignature(any *types.Any) (EthereumSignature, error) {
	if any == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnpackAny, "protobuf Any message cannot be nil")
	}

	confirm, ok := any.GetCachedValue().(EthereumSignature)
	if !ok {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrUnpackAny, "cannot unpack Any into EthereumSignature %T", any)
	}

	return confirm, nil
}


func PackSignature(signature EthereumSignature) (*types.Any, error) {
	msg, ok := signature.(proto.Message)
	if !ok {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrPackAny, "cannot proto marshal %T", signature)
	}

	anyEvent, err := types.NewAnyWithValue(msg)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrPackAny, err.Error())
	}

	return anyEvent, nil
}
