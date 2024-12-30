import { loadFixture, ethers, expect, time } from "./setup";

describe("DutchAuction", function() {
  async function deploy() {
    // const [ user ] = await ethers.getSigners
    const Factory = await ethers.getContractFactory("DutchAuction");
    const auction = await Factory.deploy(
      10000000,
      1,
      "item"
    );
    // await auction.deployed();

    return { auction }
  }

  // it("allows to buy", async function() {
  //   const { auction } = await loadFixture(deploy);
  //   await time.increase(60);

  //   const latest = await time.latest();
  //   const newLatest = latest + 1;
  //   await time.setNextBlockTimestamp(newLatest);

  //   const startPrice = await auction.startingPrice();
  //   const startAt = await auction.startAt();
  //   const elapsed = ethers.BigNumber.from(newLatest).sub(startAt);
  //   const discount = elapsed.mul(await auction.discountRate());
  //   // const price = startPrice.sub(discount);

  //   const buyTx = await auction.buy({value: price});
  //   await buyTx.wait();

  //   expect(
  //     await ethers.provider.getBalance(auction.address)
  //   ).to.eq(price);

  //   await expect(buyTx).to.changeEtherBalance(user, -price);
  // });

});