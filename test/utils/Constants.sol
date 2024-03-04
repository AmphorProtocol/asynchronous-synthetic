//SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import { Test } from "forge-std/Test.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { AsyncSynthVault } from "@src/AsyncSynthVault.sol";
import { IPermit2 } from "permit2/src/interfaces/IPermit2.sol";
import { VmSafe } from "forge-std/Vm.sol";
import { Upgrades, Options } from "openzeppelin-foundry-upgrades/Upgrades.sol";
import { UpgradeableBeacon } from
    "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import { BeaconProxy } from
    "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "forge-std/console.sol"; //todo remove

abstract contract Constants is Test {
    // ERC20 tokens
    ERC20 immutable DAI = ERC20(vm.envAddress("DAI_MAINNET"));
    ERC20 immutable USDC = ERC20(vm.envAddress("USDC_MAINNET"));
    ERC20 immutable USDT = ERC20(vm.envAddress("USDT_MAINNET"));
    ERC20 immutable WETH = ERC20(vm.envAddress("WETH_MAINNET"));
    ERC20 immutable ETH = ERC20(vm.envAddress("ETH_MAINNET"));
    ERC20 immutable WSTETH = ERC20(vm.envAddress("WSTETH_MAINNET"));
    ERC20 immutable STETH = ERC20(vm.envAddress("STETH_MAINNET"));
    ERC20 immutable WBTC = ERC20(vm.envAddress("WBTC_MAINNET"));

    uint8 decimalsOffset = 0;

    //ERC20 whales
    address immutable USDC_WHALE = vm.envAddress("USDC_WHALE");
    // Future Owner
    address immutable amphorLabs = vm.envAddress("AMPHORLABS_ADDRESS");

    // Permit2
    IPermit2 immutable permit2 = IPermit2(vm.envAddress("PERMIT2"));

    // Fees
    uint16 fees = uint16(vm.envUint("INITIAL_FEES_AMOUNT"));

    // Vault tested
    string vaultTestedName = vm.envString("VAULT_TESTED");
    AsyncSynthVault vaultTested;

    // USDC vault
    string vaultNameUSDC = vm.envString("SYNTHETIC_USDC_V1_NAME");
    string vaultSymbolUSDC = vm.envString("SYNTHETIC_USDC_V1_SYMBOL");
    AsyncSynthVault vaultUSDC;

    // WSTETH vault
    string vaultNameWSTETH = vm.envString("SYNTHETIC_WSTETH_V1_NAME");
    string vaultSymbolWSTETH = vm.envString("SYNTHETIC_WSTETH_V1_SYMBOL");
    AsyncSynthVault vaultWSTETH;

    // WBTC vault
    string vaultNameWBTC = vm.envString("SYNTHETIC_WBTC_V1_NAME");
    string vaultSymbolWBTC = vm.envString("SYNTHETIC_WBTC_V1_SYMBOL");
    AsyncSynthVault vaultWBTC;

    // Zapper
    //AsyncVaultZapper immutable zapper = new AsyncVaultZapper(permit2);

    // Users
    VmSafe.Wallet user1 = vm.createWallet("user1");
    VmSafe.Wallet user2 = vm.createWallet("user2");
    VmSafe.Wallet user3 = vm.createWallet("user3");
    VmSafe.Wallet user4 = vm.createWallet("user4");
    VmSafe.Wallet user5 = vm.createWallet("user5");
    VmSafe.Wallet user6 = vm.createWallet("user6");
    VmSafe.Wallet user7 = vm.createWallet("user7");
    VmSafe.Wallet user8 = vm.createWallet("user8");
    VmSafe.Wallet user9 = vm.createWallet("user9");
    VmSafe.Wallet user10 = vm.createWallet("user10");
    VmSafe.Wallet[] users;

    // Wallet
    VmSafe.Wallet address0 = VmSafe.Wallet({
        addr: address(0),
        publicKeyX: 0,
        publicKeyY: 0,
        privateKey: 0
    });

    // Else
    int256 immutable bipsDivider = 10_000;

    constructor() {
        vm.label(address(DAI), "DAI");
        vm.label(address(USDC), "USDC");
        vm.label(address(USDT), "USDT");
        vm.label(address(WETH), "WETH");
        vm.label(address(ETH), "ETH");
        vm.label(address(WSTETH), "WSTETH");
        vm.label(address(STETH), "STETH");
        vm.label(address(WBTC), "WBTC");

        vm.label(address(amphorLabs), "amphorLabs");
        vm.label(address(permit2), "permit2");

        //vm.label(address(zapper), "zapper");

        users.push(user1);
        users.push(user2);
        users.push(user3);
        users.push(user4);
        users.push(user5);
        users.push(user6);
        users.push(user7);
        users.push(user8);
        users.push(user9);
        users.push(user10);

        Options memory deploy;
        deploy.constructorData = abi.encode(permit2);

        // UpgradeableBeacon beacon = UpgradeableBeacon(
        //     Upgrades.deployBeacon("AsyncSynthVault.sol", amphorLabs, deploy)
        // );

        // vaultUSDC = _proxyDeploy(
        //     beacon, amphorLabs, USDC, vaultNameUSDC, vaultSymbolUSDC
        // );
        vm.startPrank(amphorLabs);
        vaultUSDC = new AsyncSynthVault(permit2);
        vaultUSDC.initialize(
            fees, amphorLabs, USDC, vaultNameUSDC, vaultSymbolUSDC
        );
        vm.label(address(vaultUSDC), "vaultUSDC");
        vm.label(address(vaultUSDC.pendingSilo()), "vaultUSDC.pendingSilo");
        vm.label(address(vaultUSDC.claimableSilo()), "vaultUSDC.claimableSilo");

        // vaultWSTETH = _proxyDeploy(
        //     beacon, amphorLabs, WSTETH, vaultNameWSTETH, vaultSymbolWSTETH
        // );
        vaultWSTETH = new AsyncSynthVault(permit2);
        vaultWSTETH.initialize(
            fees, amphorLabs, WSTETH, vaultNameWSTETH, vaultSymbolWSTETH
        );
        vm.label(address(vaultWSTETH), "vaultWSTETH");
        vm.label(address(vaultWSTETH.pendingSilo()), "vaultWSTETH.pendingSilo");
        vm.label(
            address(vaultWSTETH.claimableSilo()), "vaultWSTETH.claimableSilo"
        );

        // vaultWBTC = _proxyDeploy(
        //     beacon, amphorLabs, WBTC, vaultNameWBTC, vaultSymbolWBTC
        // );
        vaultWBTC = new AsyncSynthVault(permit2);
        vaultWBTC.initialize(
            fees, amphorLabs, WBTC, vaultNameWBTC, vaultSymbolWBTC
        );
        vm.label(address(vaultWBTC), "vaultWBTC");
        vm.label(address(vaultWBTC.pendingSilo()), "vaultWBTC.pendingSilo");
        vm.label(address(vaultWBTC.claimableSilo()), "vaultWBTC.claimableSilo");
        vm.stopPrank();
        if (
            keccak256(abi.encodePacked(vaultTestedName))
                == keccak256(abi.encodePacked("WSTETH"))
        ) {
            vaultTested = vaultWSTETH;
        } else if (
            keccak256(abi.encodePacked(vm.envString("VAULT_TESTED")))
                == keccak256(abi.encodePacked("WBTC"))
        ) {
            vaultTested = vaultWBTC;
        } else {
            console.log("vaultTestedName: ", vaultTestedName);
            vaultTested = vaultUSDC;
        }
    }

    // function _proxyDeploy(
    //     UpgradeableBeacon beacon,
    //     address owner,
    //     ERC20 underlying,
    //     string memory vaultName,
    //     string memory vaultSymbol
    // )
    //     internal
    //     returns (AsyncSynthVault)
    // {
    //     BeaconProxy proxy = BeaconProxy(
    //         payable(
    //             Upgrades.deployBeaconProxy(
    //                 address(beacon),
    //                 abi.encodeCall(
    //                     AsyncSynthVault.initialize,
    //                     (fees, owner, underlying, vaultName, vaultSymbol)
    //                 )
    //             )
    //         )
    //     );

    //     return AsyncSynthVault(address(proxy));
    // }
}
