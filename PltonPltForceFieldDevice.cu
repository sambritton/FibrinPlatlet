#include "PltonPltForceFieldDevice.h"
#include "PlateletForceDevice.h"
#include "NodeSystemDevice.h"

//for a given platelet, apply force from other platelets
void PltInteractionPltOnDevice(
  	GeneralParams& generalParams,
  	PltInfoVecs& pltInfoVecs,
  	AuxVecs& auxVecs) {


	thrust::counting_iterator<unsigned> counter(0);
    thrust::for_each(
      	thrust::make_zip_iterator(
        	thrust::make_tuple(
				counter,
        		auxVecs.idPlt_value.begin(),
          		pltInfoVecs.pltLocX.begin(),
          		pltInfoVecs.pltLocY.begin(),
          		pltInfoVecs.pltLocZ.begin())),
    thrust::make_zip_iterator(
        thrust::make_tuple(
				counter,
        		auxVecs.idPlt_value.begin(),
          		pltInfoVecs.pltLocX.begin(),
          		pltInfoVecs.pltLocY.begin(),
          		pltInfoVecs.pltLocZ.begin())) + generalParams.maxPltCount,

         PltonPltForceFunctor(
             generalParams.pltMaxConn,
             generalParams.pltRForce,
             generalParams.pltForce,
             generalParams.pltR,
             generalParams.maxPltCount,
             thrust::raw_pointer_cast(pltInfoVecs.pltLocX.data()),
             thrust::raw_pointer_cast(pltInfoVecs.pltLocY.data()),
             thrust::raw_pointer_cast(pltInfoVecs.pltLocZ.data()),
             thrust::raw_pointer_cast(pltInfoVecs.pltForceX.data()),
             thrust::raw_pointer_cast(pltInfoVecs.pltForceY.data()),
             thrust::raw_pointer_cast(pltInfoVecs.pltForceZ.data()),
             thrust::raw_pointer_cast(auxVecs.idPlt_value_expanded.data()),//plt neighbors
             thrust::raw_pointer_cast(auxVecs.keyPltBegin.data()),
             thrust::raw_pointer_cast(auxVecs.keyPltEnd.data()) ) );
};