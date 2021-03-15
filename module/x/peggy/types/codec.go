package types

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/msgservice"
)

// ModuleCdc is the codec for the module
var ModuleCdc = codec.NewLegacyAmino()

func init() {
	RegisterCodec(ModuleCdc)
}

// RegisterInterfaces registers the interfaces for the proto stuff
func RegisterInterfaces(registry types.InterfaceRegistry) {
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgSubmitConfirm{},
		&MsgSubmitClaim{},
		&MsgSendToEth{},
		&MsgRequestBatch{},
		&MsgCancelSendToEth{},
	)

	registry.RegisterInterface(
		"peggy.v1beta1.EthereumClaim",
		(*EthereumClaim)(nil),
		&DepositClaim{},
		&WithdrawClaim{},
		&ERC20DeployedClaim{},
		&LogicCallExecutedClaim{},
	)

	registry.RegisterInterface(
		"peggy.v1beta1.EthereumClaim",
		(*Confirm)(nil),
		&DepositClaim{},
		&WithdrawClaim{},
		&ERC20DeployedClaim{},
		&LogicCallExecutedClaim{},
	)

	msgservice.RegisterMsgServiceDesc(registry, &_Msg_serviceDesc)
}

// RegisterCodec registers concrete types on the Amino codec
func RegisterCodec(cdc *codec.LegacyAmino) {
	cdc.RegisterInterface((*EthereumClaim)(nil), nil)
	cdc.RegisterConcrete(&MsgDelegateKey{}, "peggy/MsgDelegateKey", nil)
	cdc.RegisterConcrete(&MsgSubmitConfirm{}, "peggy/MsgSubmitConfirm", nil)
	cdc.RegisterConcrete(&MsgSubmitClaim{}, "peggy/MsgSubmitClaim", nil)
	cdc.RegisterConcrete(&MsgSendToEth{}, "peggy/MsgSendToEth", nil)
	cdc.RegisterConcrete(&MsgRequestBatch{}, "peggy/MsgRequestBatch", nil)
	cdc.RegisterConcrete(&Valset{}, "peggy/Valset", nil)
	cdc.RegisterConcrete(&MsgCancelSendToEth{}, "peggy/MsgCancelSendToEth", nil)
	cdc.RegisterConcrete(&OutgoingTxBatch{}, "peggy/OutgoingTxBatch", nil)
	cdc.RegisterConcrete(&OutgoingTransferTx{}, "peggy/OutgoingTransferTx", nil)
	cdc.RegisterConcrete(&ERC20Token{}, "peggy/ERC20Token", nil)
	cdc.RegisterConcrete(&IDSet{}, "peggy/IDSet", nil)
	cdc.RegisterConcrete(&Attestation{}, "peggy/Attestation", nil)
}
