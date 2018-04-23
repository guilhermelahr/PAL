-- clean up
DROP TYPE "T_PARAMS";
DROP TYPE "T_STATE";
DROP TABLE "SIGNATURE";
CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_DROP"('DEVUSER', 'P_CMS');
DROP TABLE "#PARAMS";
DROP TABLE "STATE";

-- procedure setup
CREATE TYPE "T_PARAMS" AS TABLE ("NAME" VARCHAR(60), "INTARGS" INTEGER, "DOUBLEARGS" DOUBLE, "STRINGARGS" VARCHAR(100));
CREATE TYPE "T_STATE" AS TABLE ("NAME" VARCHAR(50), "VALUE" VARCHAR(100));
CREATE COLUMN TABLE "SIGNATURE" ("POSITION" INTEGER, "SCHEMA_NAME" NVARCHAR(256), "TYPE_NAME" NVARCHAR(256), "PARAMETER_TYPE" VARCHAR(7));
INSERT INTO "SIGNATURE" VALUES (1, 'DEVUSER', 'MODEL', 'IN');
INSERT INTO "SIGNATURE" VALUES (2, 'DEVUSER', 'T_PARAMS', 'IN');
INSERT INTO "SIGNATURE" VALUES (3, 'DEVUSER', 'T_STATE', 'OUT');
CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_CREATE"('AFLPAL', 'CREATE_PAL_MODEL_STATE', 'DEVUSER', 'P_CMS', "SIGNATURE");

-- table setup
CREATE LOCAL TEMPORARY COLUMN TABLE "#PARAMS" LIKE "T_PARAMS";
CREATE COLUMN TABLE "STATE" LIKE "T_STATE";

-- parameters
INSERT INTO "#PARAMS" VALUES ('ALGORITHM', 3, null, null); -- 1: SVM, 2: Random DT, 3: Decision Tree, 4: Cluster Assignment, 5: LDA Inference, 6: Binning, 7: Naive Bayes, 8: PCA, 9: BPNN

-- call : results in table
TRUNCATE TABLE "STATE";
CALL "P_CMS" ("MODEL", "#PARAMS", "STATE") WITH OVERVIEW;
SELECT * FROM "STATE";
SELECT * FROM "SYS"."M_AFL_STATES";
SELECT * FROM "SYS"."M_AFL_FUNCTIONS";