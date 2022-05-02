/* What is Solidity?
Object-oriented, high-level language influenced by C++, Python and JavaScript.
Solidity's code is encapsulated in contracts. A contract is the fundamental building block of Ethereum applications — 
all variables and functions belong to a contract, and this will be the starting point of all your projects. 
*/


/*
pragma solidity is the way of declaring the solidity compiler.
Here, in 0.5.0, 0= version number, 5= major build, 0= minor build.

What is caret (^)?
For example:- pragma solidity ^0.4.24;
First, the version number 0.4.24 refers to major build 4 and minor build 24. 
The caret symbol (^) before the version number tells Solidity that it can use the latest build in a major version range.
*/
pragma solidity >=0.5.0 <0.6.0;

// Created a contract named ZombieFactory
contract ZombieFactory {

    /*
    Events:
    Events are a way for your contract to communicate that something happened on the blockchain to your app front-end, 
    which can be 'listening' for certain events and take action when they happen.
    */
    // Declare the event
    event NewZombie(uint zombieId, string name, uint dna);

    /* 
    State variables:
    State variables are permanently stored in contract storage. This means they're written to the Ethereum blockchain.
    uint is unsigned integer (positive numbers), it's an alias for uint256. We can declare them with less bits,
    for eg:- uint8, uint16, uint 32, etc.
    */
    uint dnaDigits = 16;

    /*
    Math operations in solidity:
    Addition: x + y
    Subtraction: x - y,
    Multiplication: x * y,
    Division: x / y,
    Modulus / remainder: x % y (for example, 13 % 5 is 3, because if you divide 5 into 13, 3 is the remainder),
    Power: x ** y
    */
    uint dnaModulus = 10 ** dnaDigits;

    /*
    Structs:
    Structs allow you to create more complicated data types that have multiple properties.
    */
    struct Zombie {
        string name;
        uint dna;
    }

    /*
    Arrays:
    Format: "DATA_TYPE[] VISIBILITY (public/private) NAME"
    Two types: fixed arrays & dynamic arrays.

    Fixed array example: uint[2] fixedArray;
    Dynamic array example: uint[] dynamicArray;


    Public means other contracts would then be able to read from, but not write to, this array. 
    So this is a useful pattern for storing public data in your contract.
    Below we've created a public dynamic array of struct Zombie named zombies.
    */
    Zombie[] public zombies;

    /*
    Functions:
    We've created a public function named createZombies that contains two paraeters (_name and _dna).
    the word memory means _name variable is stored in memory (not written to the blockchain), 
    This is required for all reference types such as arrays, structs, mappings, and strings.
    There are two ways in which you can pass an argument to a Solidity function:
    - By value
    - By reference

    Usually functional parameter variable names start with an underscore (_) (it's a good practice).
    */

    /*
    Private/Public functions:
    In Solidity, functions are public by default. This means anyone (or any other contract) can call your contract's function and execute its code.
    Thus it's good practice to mark your functions as private by default, and then only make public the functions you want to expose to the world.

    Below, _createZombie function is private, this means only other functions within our contract will be able to call this function and add to the zombies array.
    If the function is private, then start the function name with an underscore (_). 
    */
    function _createZombie(string memory _name, uint _dna) private {
        /*
        Pushing to dynamic array:
        We're pushing values of _name and _dna (functional arguments) to zombies array.
        For eg:-
        people.push(Person(16, "Vitalik"));
        Age 16 and name Vitalik is added to people[[16, Vitalik]] array, where Person is just a complex data type (struct)/single element of the array.
        */
        // zombies.push(Zombie(_name, _dna));
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // Fire an event to let the app know the function was called:
        emit NewZombie(id, _name, _dna);
    }

    /*
    Return values:
    It returns a value from a function.
    eg:-
    string greeting = "What's up dog";
    function sayHello() public returns (string memory) {
      return greeting;
    }
    In Solidity, the function declaration contains the type of the return value (in this case string).

    Function modifiers:
    View: it only views the data but doesn't modify it.
    eg:-
    function sayHello() public view returns (string memory) {

    Pure: it doesn't access any data in the app.
    eg:-
    function _multiply(uint a, uint b) private pure returns (uint) {
        return a * b;
    }
    */
    function _generateRandomDna(string memory _str) private view returns (uint) {
        /*
        Keccak256 and Typecasting:
        Ethereum has the hash function keccak256 built in, which is a version of SHA3.
        A hash function basically maps an input into a random 256-bit hexadecimal number. A slight change in the input will cause a large change in the hash.

        uint8 a = 5;
        uint b = 6;
        // throws an error because a * b returns a uint, not uint8:
        uint8 c = a * b;
        // we have to typecast b as a uint8 to make it work:
        uint8 c = a * uint8(b);
        In the above, a * b returns a uint, but we were trying to store it as a uint8, which could cause potential problems. 
        By casting it as a uint8, it works and the compiler won't throw an error.
        */
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // We're going to create a public function that takes an input, the zombie's name, and uses the name to create a zombie with random DNA.
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
