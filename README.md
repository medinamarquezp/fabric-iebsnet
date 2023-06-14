## Running the IEBS network

You can use the `./network.sh` script to stand up the Fabric IEBS network. The IEBS network has two peer organizations with one peer each and a single node raft ordering service. You can also use the `./network.sh` script to create channels and deploy chaincode.

### Deployment

```sh
./network.sh up createChannel -c universidades
```
