/** @format */

import {ethers} from "hardhat";

import {promisify} from "util";

const request = require("request");

const ExcelJS = require("exceljs");

const fs = require("fs").promises;

const requestPromise = promisify(request);

describe("Hyperdust_HYDT_Price", () => {
    describe("sendRequest", () => {
        it("sendRequest", async () => {
            const accounts = await ethers.getSigners();

            console.info(accounts[3].address)

        });
    });
});
