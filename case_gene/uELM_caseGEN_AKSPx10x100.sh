#!/bin/bash

set -e

# Create a test case uELM_AKSP_I1850uELMCNPRDCTCBC

E3SM_DIN="/gpfs/alpine2/cli180/proj-shared/wangd/inputdata"
EXPID="AKSPx10x100"

E3SM_SRCROOT=$PWD/../
CASEDIR="$E3SM_SRCROOT/e3sm_cases/uELM_${EXPID}_I1850uELMCNPRDCTCBC"
echo "E3SM_SRCROOT: $E3SM_SRCROOT"
echo "E3SM_DIN: $E3SM_DIN"

DATA_ROOT="/gpfs/alpine2/cli180/proj-shared/wangd/kiloCraft/NA_AOI_datasets/"
CASE_DATA="${DATA_ROOT}/${EXPID}"

DOMAIN_FILE="${EXPID}_domain.lnd.Daymet_NA.1km.1d.c240524.nc"
SURFDATA_FILE="${EXPID}_surfdata.Daymet_NA.1km.1d.c240524.nc"

PECOUNT="44"

\rm -rf "${CASEDIR}"

#${E3SM_SRCROOT}/cime/scripts/create_newcase --case "${CASEDIR}" --mach summitPlus --compiler pgi --mpilib spectrum-mpi --compset I1850uELMCNPRDCTCBC --res ELM_USRDAT --pecount "${PECOUNT}" --handle-preexisting-dirs r --srcroot "${E3SM_SRCROOT}"

${E3SM_SRCROOT}/cime/scripts/create_newcase --case "${CASEDIR}" --mach summitplus --compiler pgi --mpilib spectrum-mpi --compset I1850uELMCNPRDCTCBC --res ELM_USRDAT  --handle-preexisting-dirs r --srcroot "${E3SM_SRCROOT}"

cd "${CASEDIR}"

./xmlchange DIN_LOC_ROOT="${E3SM_DIN}"

./xmlchange DIN_LOC_ROOT_CLMFORC="${CASE_DATA}"

./xmlchange ELM_FORCE_COLDSTART=on

./xmlchange DATM_MODE=uELM_NADaymet

./xmlchange DATM_CLMNCEP_YR_START=2014

./xmlchange DATM_CLMNCEP_YR_END=2014

./xmlchange ATM_NCPL=24

./xmlchange STOP_N=1

./xmlchange STOP_OPTION=ndays

./xmlchange NTASKS_LND=42000
./xmlchange NTASKS_ATM=42
./xmlchange NTASKS_ATM=168

./xmlchange MAX_MPITASKS_PER_NODE=42

./xmlchange ATM_DOMAIN_PATH="${CASE_DATA}/domain_surfdata/"

./xmlchange ATM_DOMAIN_FILE="${DOMAIN_FILE}"

./xmlchange LND_DOMAIN_PATH="${CASE_DATA}/domain_surfdata/"

./xmlchange LND_DOMAIN_FILE="${DOMAIN_FILE}"

./xmlchange JOB_WALLCLOCK_TIME="4:00"

./xmlchange PIO_TYPENAME="pnetcdf"
# Use 64bit_data for large variables
./xmlchange PIO_NETCDF_FORMAT="64bit_data"

# Set SCORPIO buffer size to 64 MB
./xmlchange PIO_BUFFER_SIZE_LIMIT=67108864

echo "fsurdat = '${CASE_DATA}/domain_surfdata/${SURFDATA_FILE}'
      hist_nhtfrq=-24
      hist_mfilt=31
     " >> user_nl_elm

./case.setup --reset

./case.setup

#./case.build --clean

#./case.build
