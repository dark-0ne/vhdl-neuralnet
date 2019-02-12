# vhdl-neuralnet
#### Simple implementation of a 784-64-10 Artificial Neural Net for MNIST dataset classification with vhdl

Both layers use sigmoid as activation function. This function is approximated and stored in rom. Because of the limited amount of resources on a FPGA device, Only 1 actual neuron is dedicated resources to on device therefore total of 78 cycles are required for network output.

Note: Due to the high number of Flip Flops used in design synthesis of the top module may take up to 3-4 hours on a slow device.
