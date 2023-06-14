#!/bin/bash

function createmadrid() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/madrid/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/madrid/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-madrid --tls.certfiles "${PWD}/organizations/fabric-ca/madrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-madrid.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-madrid.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-madrid.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-madrid.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/madrid/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-madrid --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/madrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-madrid --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/madrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-madrid --id.name madridadmin --id.secret madridadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/madrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-madrid -M "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/msp" --csr.hosts madrid --tls.certfiles "${PWD}/organizations/fabric-ca/madrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/madrid/msp/config.yaml" "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-madrid -M "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/tls" --enrollment.profile tls --csr.hosts madrid --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/madrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/tls/keystore/"* "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/madrid/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/madrid/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/madrid/tlsca"
  cp "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/madrid/tlsca/tlsca.madrid-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/madrid/ca"
  cp "${PWD}/organizations/peerOrganizations/madrid/peers/madrid/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/madrid/ca/ca.madrid-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-madrid -M "${PWD}/organizations/peerOrganizations/madrid/users/User1@madrid/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/madrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/madrid/msp/config.yaml" "${PWD}/organizations/peerOrganizations/madrid/users/User1@madrid/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://madridadmin:madridadminpw@localhost:7054 --caname ca-madrid -M "${PWD}/organizations/peerOrganizations/madrid/users/Admin@madrid/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/madrid/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/madrid/msp/config.yaml" "${PWD}/organizations/peerOrganizations/madrid/users/Admin@madrid/msp/config.yaml"
}

function createbogota() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/bogota/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/bogota/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-bogota --tls.certfiles "${PWD}/organizations/fabric-ca/bogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bogota.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bogota.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bogota.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-bogota.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/bogota/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-bogota --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/bogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-bogota --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/bogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-bogota --id.name bogotaadmin --id.secret bogotaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/bogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-bogota -M "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/msp" --csr.hosts bogota --tls.certfiles "${PWD}/organizations/fabric-ca/bogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bogota/msp/config.yaml" "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-bogota -M "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/tls" --enrollment.profile tls --csr.hosts bogota --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/bogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/tls/keystore/"* "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/tls/server.key"

  mkdir -p "${PWD}/organizations/peerOrganizations/bogota/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/bogota/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/bogota/tlsca"
  cp "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/bogota/tlsca/tlsca.bogota-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/bogota/ca"
  cp "${PWD}/organizations/peerOrganizations/bogota/peers/bogota/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/bogota/ca/ca.bogota-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-bogota -M "${PWD}/organizations/peerOrganizations/bogota/users/User1@bogota/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/bogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bogota/msp/config.yaml" "${PWD}/organizations/peerOrganizations/bogota/users/User1@bogota/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://bogotaadmin:bogotaadminpw@localhost:8054 --caname ca-bogota -M "${PWD}/organizations/peerOrganizations/bogota/users/Admin@bogota/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/bogota/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/bogota/msp/config.yaml" "${PWD}/organizations/peerOrganizations/bogota/users/Admin@bogota/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/iebs

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/iebs

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/iebs/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/msp" --csr.hosts orderer --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/iebs/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/tls" --enrollment.profile tls --csr.hosts orderer --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/msp/tlscacerts/tlsca.iebs-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/iebs/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/iebs/orderers/orderer/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/iebs/msp/tlscacerts/tlsca.iebs-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/iebs/users/Admin@iebs/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/iebs/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/iebs/users/Admin@iebs/msp/config.yaml"
}
