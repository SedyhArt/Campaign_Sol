/** @format */

const path = require("path");
const fs = require("fs-extra");
const solc = require("solc");

const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, "contracts", "Campaign.sol");
const source = fs.readFileSync(campaignPath, "utf8");

const input = {
    language: "Solidity",
    sources: {
        "Campaign.sol": {
            content: source
        }
    },
    settings: {
        outputSelection: {
            "*": {
                "*": ["*"]
            }
        }
    }
};

const output = JSON.parse(solc.compile(JSON.stringify(input)));
console.log(JSON.parse(solc.compile(JSON.stringify(input))));
