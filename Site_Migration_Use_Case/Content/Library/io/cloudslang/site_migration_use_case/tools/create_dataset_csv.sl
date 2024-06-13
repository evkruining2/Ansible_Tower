########################################################################################################################
#!!
#! @description: Create an example CSV file in the root folder of the RPA server (c:\) to be used in the "Select Row from CSV" flow
#!!#
########################################################################################################################
namespace: io.cloudslang.site_migration_use_case.tools
flow:
  name: create_dataset_csv
  inputs:
    - path: "c:\\Demo\\Data\\"
    - filename: laptops.csv
  workflow:
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: '${path+filename}'
            - text: |
                Item Number,Item Name,Item Description,Item Price
                66099,WOWSZUP,ProBook 640G2 i5-BE00U Notebook PC,1180.81
                66098,WOWSZU,HP ProBook 640 with Bilingual Keyboard (English & French Windows 7 installed),1180.81
                66097,WOWSBUP,HP ProBook 640 with with an Upgrade to 2SBGB SED SSD English Keyboard,1534.36
                66096,WOWSBUPA,HP ProBook 640 with an Upgrade to 2SBGB SED SSD Bilingual Keyboard (English & French Windows 10 installed),1534.36
                66095,ARHZZUP,ProBook 640G4 i5-83SO 4GB SO0GB W10P64 3/3/0  English Keyboard,1180.81
                66094,ARHZZUPA,ProBook 640G4 i5-83SO 4GB SO0GB W10P64 3/3/0 Bilingual Keyboard (English & French Windows 10 installed),1180.81
                66093,ARHBEUP,ProBook 640G4 i5-83SO 4GB 2SBGB PCIe NVMe W10P64 3/3/0  English Keyboard,1534.36
                66092,ARHBEUPA,ProBook 640G4 i5-83SO 4GB 2SBGB PCIe NVMe W10P64 3/3/0 Bilingual Keyboard (English & French Windows 10 installed),1534.36
                66091,WOWSPUP,HP EliteBook 840 G3 i5-BE00U  Notebook PC,1311.38
                66090,WOWSPUPA,HP EliteBook 840 G2 with Bilingual Keyboard (English & French Windows 10 installed),1311.38
                66089,WOWBOUP,HP EliteBook 840 with an Upgrade to  2SBGB M2 SATA-3 TLC SSD English Keyboard,1453
                66088,WOWBOUPA,HP EliteBook 840 with an Upgrade to 2SBGB M2 SATA-3 TLC SSD Bilingual Keyboard (English & French Windows 10 installed),1453
                66087,ZSTABUP,HP EliteBook 840 with an Upgrade to 512GB M2 SATA-3 TLC SSD Bilingual Keyboard (English & French Windows 10 installed)   ,1589.28
                66086,ZSTABUPA,HP EliteBook 840 with an Upgrade to 512GB M2 SATA-3 TLC SSD Bilingual Keyboard (English & French Windows 10 installed),1589.28
                66085,ARHAAUP,EliteBook 840G5 i5-83SO 8GB 2SBGB PCIe NVMe W10P64 3/3/0 English Keyboard,1453
                66084,ARHAAUPA,EliteBook 840G5 i5-83SO 8GB 2SBGB PCIe NVMe W10P64 3/3/0 Bilingual Keyboard (English & French Windows 10 installed),1453
                66083,ARHZSUP,EliteBook  840G5 i5-83SO 8GB 512GB PCIe NVMe W10P64 3/3/0  SSD English Keyboard,1589.28
                66082,ARHZSUPA,EliteBook  840G5 i5-83SO 8GB 512GB PCIe NVMe W10P64 3/3/0  Bilingual Keyboard (English & French Windows 10 installed),1589.28
                66081,CQXPBUP,HP Zbook 14 G4 i5-7300 Notebook PC,1525.13
                66080,CQXPBUPA,HP Zbook 14 with Bilingual Keyboard (English & French Windows 10 installed),1525.13
                66079,WOWBIUP,HP EliteBook 8SO G3 i7-6BO0U Notebook PC,1480.43
                66078,WOWBIUPA,HP EliteBook 8SO with Bilingual Keyboard (English & French Windows 10 installed),1480.43
                66077,WOWBZUP,HP EliteBook 8SO with an Upgrade to  2SBGB M2 SATA-3 TLC SSD English Keyboard,1802.53
                66076,WOWBZUPA,HP EliteBook 8SO with an Upgrade to 2SBGB M2 SATA-3 TLC SSD Bilingual Keyboard (English & French Windows10 installed),1802.53
                66075,ZSTAQUP,HP EliteBook 8SO with an Upgrade to 5126GB M2 SATA-3 TLC SSD English Keyboard,1738.33
                66074,ZSTAQUPA,HP EliteBook 8SO with an Upgrade to 5126GB M2 SATA-3 TLC SSD Bilingual Keyboard (English & French Windows 10 installed),1738.33
                66073,YFQSBUP ,HP EliteBook 8SO with an Upgrade to  2SBGB M2 SATA-3 TLC SSD  and 16GB RAM ( 2 X 8GB) English Keyboard,1727.31
                66072,YFQSBUPA,HP EliteBook 8SO with an Upgrade to 2SBGB M2 SATA-3 TLC SSD and 16GB RAM ( 2 X 8GB) Bilingual Keyboard (English & French Windows 10 installed),1727.31
                66071,CYFBIUP,HP EliteBook 8SO with Downgrade to i5-BE00U English Keyboard,1380.43
                66070,CYFBIUPA,HP EliteBook 8SO G3 with Downgrade to i5-BE00U Bilingual Keyboard (English & French Windows 10 installed),1380.43
                66069,CYFBOUP,HP EliteBook 8SO with Downgrade to i5-BE00U and Upgrade to  2SBGB M2 SATA-3 TLC SSD English Keyboard,1522.53
                66068,CYFBOUPA,HP EliteBook 8SO with Downgrade to i5-BE00U and Upgrade to 2SBGB M2 SATA-3 TLC SSD Bilingual Keyboard (English & French Windows10 installed),1522.53
                66067,CYFSAUP,HP EliteBook 8SO with Downgrade to i5-BE00U and Upgrade to 5126GB M2 SATA-3 TLC SSD English Keyboard,1658.33
                66066,CYFSAUPA,HP EliteBook 8SO with Downgrade to i5-BE00U andn Upgrade to 5126GB M2 SATA-3 TLC SSD Bilingual Keyboard (English & French Windows 10 installed),1658.33
                66065,ARHSBUP,EliteBook 8SOG5 i7-86SO 8GB 2SBGB PCIe NVMe W10P64 3/3/0  English Keyboard,1802.53
                66064,ARHSBUPA,EliteBook 8SOG5 i7-86SO 8GB 2SBGB PCIe NVMe W10P64 3/3/0 Bilingual Keyboard (English & French Windows10 installed),1802.53
                66063,ARHSOUPA,EliteBook 8SOG5 i7-86SO 8GB 512SSD0 512GB PCIe NVMe W10P64 3/3/0  English Keyboard,1738.33
                66062,ARHSOUP,EliteBook 8SOG5 i7-86SO 8GB 512SSD0 512GB PCIe NVMe W10P64 3/3/0  Bilingual Keyboard (English & French Windows 10 installed),1738.33
                66061,WOWBEUP,HP EliteBook 820 G3 i5-BE00U Notebook PC,1836.05
                66060,WOWBEUPA,HP EliteBook 820 G2 with Bilingual Keyboard (English & French Windows 10 installed),1836.05
                66059,ZSTSOUP,HP EliteBook 820 with an Upgrade to 5126GB M2 SATA-3 TLC SSD English Keyboard,1786.05
                66058,ZSTSOUPA,HP EliteBook 820 with an Upgrade to 5126GB M2 SATA-3 TLC SSD Bilingual Keyboard (English & French Windows10 installed),1786.05
                66057,ARHBPUP,EliteBook 830G5 i5-83SO 8GB 2SBGB PCIe NVMe W10P64 3/3/0  English Keyboard,1836.05
                66056,ARHBPUPA,EliteBook 830G5 i5-83SO 8GB 2SBGB PCIe NVMe W10P64 3/3/0 (English & French Windows 10 installed),1836.05
                66055,ARHSAUP,EliteBook 830G5 i5-83SO 8GB 512GB PCIe NVMe W10P64 3/3/0  English Keyboard,1786.05
                66054,ARHSAUPA,EliteBook 830G5 i5-83SO 8GB 2SBSSD W10P64 3/3/0  Bilingual Keyboard (English & French Windows 10 installed),1786.05
                66053,KAJBEUA,HP Chromebook 11 G3,392.4
                66052,JZLAIUA,HP Chromebook 14,464.34
                66051,FFWAQUA,HP Chromebook 14 with Bilingual Keyboard,464.34
                66050,FFWSOUA,HP Chromebook 14 with WWAN Cellular modem installed,525.34
                66049,FFWSOUAA,HP Chromebook 14 with WWAN Cellular modem installed and  Bilingual Keyboard,525.34
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      write_to_file:
        x: 245
        'y': 221
        navigate:
          c032b358-df0b-c367-f43d-08fb966a8299:
            targetId: c0200818-3ca1-231a-28e3-1ab6ffb01fa1
            port: SUCCESS
    results:
      SUCCESS:
        c0200818-3ca1-231a-28e3-1ab6ffb01fa1:
          x: 475
          'y': 250
