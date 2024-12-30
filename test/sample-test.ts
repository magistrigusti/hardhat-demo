import { loadFixture, ethers, expect, time } from "./setup";

describe("Timelock", function() {
  async function deploy() {
    const [ owner ] = await ethers.getSigners();
    
    const Factory = await ethers.getContractFactory("Sample");
    const sample = await Factory.deploy();
    await sample.deployed();

    return { owner, sample }
  };

  async function getAt(addr: string, slot: number | string | BigNumber) {
    return await ethers.provider.getStorageAt(addr, slot)
  }

  it("checks state", async function () {
    const { sample } = await loadFixture(deploy);
    const pos = ethersBigNumber.from(
      ethers.utils.solidityKeccak256(
        ["uint"], [1]
      )
    );
    const nextPos = pos.add(ethers.BigNumber.from(1));

    const mappingPos = ethers.utils.solidityKeccak256(
      ["uint256", "uint256"], 
      [ethers.utils.hexZeroPad(sample.address, 32), 2]
    );
    const nonExistentMappingPos = ethers.utils.solidityKeccak256(
      ["uint256", "uint256"],
      [ethers.utils.hexZeroPad(owner.address, 32), 2]
    );

    const slots = [0, 1, 2, pos, nextPos, mappingPos nonExistentMappingPos ];
    slots.forEach(async (slot) => {
      console.log(slot.toString(), "--->", await getAt(sample.address, slot));
    });
  });

});





// describe("Sample", function() {
//   async function deploy() {
//     const [deployer, user] = await ethers.getSigners();
//     const SampleFactory = await ethers.getContractFactory("Sample");
//     const sample: Sample = await SampleFactory.deploy();
//     // await sample.deployed();

//     return { sample, deployer, user }
//   }

//   it("allows to call get()", async function() {
//     const { sample, deployer } = await loadFixture(deploy);
    
//     expect(await sample.get()).to.eq(42);
//   });

//   it("allows to call pay() and message()", async function() {
//     const { sample, deployer } = await loadFixture(deploy);
//     const value = 1000;
//     const tx = await sample.pay("hi", {value: value});
//     await tx.wait();

//     expect(await sample.get()).to.eq(value);
//     expect(await sample.message()).to.eq("hi");
//   });

//   // it("allows to call callMe()", async function() {
//   //   const { sample, user } = await loadFixture(deploy);

//   //   // const sampleAsUser = Sample__factory.connect(sample.address, user);
//   //   const tx = await sampleAsUser.callMe();
//   //   await tx.wait();

//   //   expect(await sampleAsUser.caller()).to.eq(user.address);
//   // });

//   it("reverts call to callErrors() with Panic", async function() {
//     const { sample, deployer } = await loadFixture(deploy);

//     await expect(sample.callError()).to.be.revertedWithPanic()
//   })
// });