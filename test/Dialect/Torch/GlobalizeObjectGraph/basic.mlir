// RUN: torch-mlir-opt -torch-globalize-object-graph -split-input-file %s | FileCheck %s

// Basic case.

// CHECK-LABEL:   torch.global_slot @b : !torch.bool  {
// CHECK:           %[[INIT:.*]] = torch.constant.bool true
// CHECK:           torch.global_slot.init %[[INIT]] : !torch.bool
// CHECK:         }

// CHECK-LABEL:   torch.global_slot @i : !torch.int  {
// CHECK:           %[[INIT:.*]] = torch.constant.int 3
// CHECK:           torch.global_slot.init %[[INIT]] : !torch.int
// CHECK:         }

// CHECK-LABEL:   torch.global_slot @f : !torch.float  {
// CHECK:           %[[INIT:.*]] = torch.constant.float 4.250000e+01
// CHECK:           torch.global_slot.init %[[INIT]] : !torch.float
// CHECK:         }

// CHECK-LABEL:   torch.global_slot @t : !torch.tensor  {
// CHECK:           %[[T:.*]] = torch.tensor.literal(dense<1.000000e+00> : tensor<1xf32>) : !torch.tensor
// CHECK:           torch.global_slot.init %[[T]] : !torch.tensor
// CHECK:         }

torch.class_type @c {
  torch.attr "b" : !torch.bool
  torch.attr "i" : !torch.int
  torch.attr "f" : !torch.float
  torch.attr "t" : !torch.tensor
}

%bool_true = torch.constant.bool true
%i = torch.constant.int 3
%f = torch.constant.float 4.250000e+01
%t = torch.tensor.literal(dense<1.0> : tensor<1xf32>) : !torch.tensor
torch.nn_module {
  torch.slot "b", %bool_true : !torch.bool
  torch.slot "i", %i : !torch.int
  torch.slot "f", %f : !torch.float
  torch.slot "t", %t : !torch.tensor
} : !torch.nn.Module<"c">

func.func private @ensure_all_slots_are_used(%arg0: !torch.nn.Module<"c">) {
  %0 = torch.prim.GetAttr %arg0["b"] : !torch.nn.Module<"c"> -> !torch.bool
  %1 = torch.prim.GetAttr %arg0["i"] : !torch.nn.Module<"c"> -> !torch.int
  %2 = torch.prim.GetAttr %arg0["f"] : !torch.nn.Module<"c"> -> !torch.float
  %3 = torch.prim.GetAttr %arg0["t"] : !torch.nn.Module<"c"> -> !torch.tensor
  return
}
