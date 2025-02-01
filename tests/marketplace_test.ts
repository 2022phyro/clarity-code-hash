import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure can list template",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("template", "mint", 
        [types.utf8("ipfs://template1")],
        wallet_1.address
      ),
      Tx.contractCall("marketplace", "list-template",
        [types.uint(1), types.uint(100), types.utf8("ipfs://metadata1")],
        wallet_1.address
      )
    ]);
    
    assertEquals(block.receipts.length, 2);
    assertEquals(block.height, 2);
    block.receipts[1].result.expectOk().expectBool(true);
  },
});

Clarinet.test({
  name: "Ensure can purchase template",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    // Test implementation
  },
});
