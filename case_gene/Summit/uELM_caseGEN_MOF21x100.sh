#!/bin/bash

set -e

# Create a test case uELM_AKSP_I1850uELMCNPRDCTCBC

E3SM_DIN="/gpfs/alpine2/cli180/proj-shared/wangd/inputdata"
EXPID="MOF21x100"

E3SM_SRCROOT=$(git rev-parse --show-toplevel)
CASEDIR="$E3SM_SRCROOT/e3sm_cases/uELM_${EXPID}_I1850uELMCNPRDCTCBC"
echo "E3SM_SRCROOT: $E3SM_SRCROOT"
echo "E3SM_DIN: $E3SM_DIN"

DATA_ROOT="/gpfs/alpine2/cli180/proj-shared/wangd/kiloCraft/NA_AOI_datasets/"
CASE_DATA="${DATA_ROOT}/${EXPID}"

DOMAIN_FILE="${EXPID}_domain.lnd.Daymet_NA.1km.1d.c240524.nc"
SURFDATA_FILE="${EXPID}_surfdata.Daymet_NA.1km.1d.c240524.nc"

PECOUNT="42"

\rm -rf "${CASEDIR}"

#${E3SM_SRCROOT}/cime/scripts/create_newcase --case "${CASEDIR}" --mach summitPlus --compiler pgi --mpilib spectrum-mpi --compset I1850uELMCNPRDCTCBC --res ELM_USRDAT --pecount "${PECOUNT}" --handle-preexisting-dirs r --srcroot "${E3SM_SRCROOT}"

${E3SM_SRCROOT}/cime/scripts/create_newcase --case "${CASEDIR}" --mach summitplus --compiler pgi --mpilib spectrum-mpi --compset I1850uELMCNPRDCTCBC --res ELM_USRDAT  --handle-preexisting-dirs r --srcroot "${E3SM_SRCROOT}"

cd "${CASEDIR}"

./xmlchange DIN_LOC_ROOT="${E3SM_DIN}"

./xmlchange DIN_LOC_ROOT_CLMFORC="${CASE_DATA}"

./xmlchange ELM_FORCE_COLDSTART="on"

./xmlchange DATM_MODE="uELM_NADaymet"

./xmlchange DATM_CLMNCEP_YR_START="2014"

./xmlchange DATM_CLMNCEP_YR_END="2014"

./xmlchange ATM_NCPL="24"

./xmlchange STOP_N="5"

./xmlchange NTASKS_LND="1"

./xmlchange NTASKS_PER_INST_LND="1"

./xmlchange STOP_OPTION="ndays"

./xmlchange PIO_TYPENAME="pnetcdf"

./xmlchange PIO_NETCDF_FORMAT="64bit_data"

./xmlchange ATM_DOMAIN_PATH="${CASE_DATA}/atm_forcing.datm7.uELM_NADaymet.1d.c231120/"

./xmlchange ATM_DOMAIN_FILE="${DOMAIN_FILE}"

./xmlchange LND_DOMAIN_PATH="${CASE_DATA}/atm_forcing.datm7.uELM_NADaymet.1d.c231120/"

./xmlchange LND_DOMAIN_FILE="${DOMAIN_FILE}"

./xmlchange JOB_WALLCLOCK_TIME="1:00"

./xmlchange USER_REQUESTED_WALLTIME="1:00"

echo "fsurdat = '${CASE_DATA}/atm_forcing.datm7.uELM_NADaymet.1d.c231120/${SURFDATA_FILE}'
      hist_nhtfrq=-120
      hist_mfilt=1
     " >> user_nl_elm

./case.setup --reset

./case.setup

#./case.build --clean

#./case.build
