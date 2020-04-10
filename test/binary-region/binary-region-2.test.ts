import { assert } from 'chai';
import { BinaryRegion2 } from "../../lib/binary-region-2";
import { htmlTemplate } from "../common";
import fs from 'fs-extra';
import { binaryRegionFilenames } from "./filenames";
import { assertSameCode } from "../../lib/utils";

suite(BinaryRegion2.name, function () {
  test('empty', () => {
    const region = new BinaryRegion2();
    const binary = region.toBuffer();
    const outputHTML = htmlTemplate(region.toHTML());
    fs.writeFileSync(binaryRegionFilenames.empty.output, outputHTML);
    assert.deepEqual(binary, Buffer.from([]));
    const expectedHTML = fs.readFileSync(binaryRegionFilenames.empty.expected, 'utf8');
    assertSameCode(outputHTML, expectedHTML);
  })
});