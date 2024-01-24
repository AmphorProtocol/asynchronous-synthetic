// // SPDX-License-Identifier: UNLICENSED
// pragma solidity 0.8.21;

// import {Script, console} from "forge-std/Script.sol";
// import {
//     AmphorSyntheticVaultWithPermit,
//     ERC20,
//     IERC20
// } from "../../src/AmphorSyntheticVaultWithPermit.sol";

// contract GOERLI_DeployAmphorSynthetic is Script {
//     function run() external {
//         // if you want to deploy a vault with a seed phrase instead of a pk, uncomment the following line
//         // string memory seedPhrase = vm.readFile(".secret");
//         // uint256 privateKey = vm.deriveKey(seedPhrase, 0);
//         uint256 privateKey = vm.envUint("PRIVATE_KEY");
//         ERC20 underlying = ERC20(vm.envAddress("AAVE_USDC_GOERLI"));
//         uint16 fees = uint16(vm.envUint("INITIAL_FEES_AMOUNT"));
//         string memory vaultName = vm.envString("SYNTHETIC_USDC_V1_NAME");
//         string memory vaultSymbol = vm.envString("SYNTHETIC_USDC_V1_SYMBOL");

//         vm.startBroadcast(privateKey);

//         SynthVault vault =
//         new SynthVaultPermit(
//                 underlying,
//                 vaultName,
//                 vaultSymbol,
//                 decimalOffset
//             );

//         vault.setFees(fees);

//         // amphorSyntheticVault.transferOwnership(amphorlabsAddress);

//         console.log(
//             "Synthetic vault USDC contract address: ",
//             address(amphorSyntheticVault)
//         );

//         vm.stopBroadcast();
//     }
// }
