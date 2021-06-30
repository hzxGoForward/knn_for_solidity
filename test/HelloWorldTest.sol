import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HelloWorld.sol";

contract TestHelloWorld{
    function testSayHigh() public {
        HelloWorld hw = HelloWorld(DeployedAddresses.HelloWorld());
        string memory expected = "Hello!";
        Assert.equal(hw.sayHi(), expected, "Wrong sayHi function");
    }
}

