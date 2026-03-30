<cfscript>
      conciliaPagos =  createObject("component","crc.cobros.operacion.ConciliacionPagosNRef");
      if (isDefined('form.BotonSel') and form.BotonSel eq 'btnAplicar'){
         errores="";
         listaID = listToArray(form.chk);
         for(i=1;i<=arrayLen(listaID);i++){
            if(!arrayIsEmpty(conciliaPagos.obtieneCuenta(listaID[i]))){
               conciliaPagos.AplicaRegistro(listaID[i]);
            }else{
               throw(message="Error: Hay registros sin cuentas registradas");
            }
         }
         location( "ConciliacionPagosNRef.cfm" );
      }
      if(isDefined('form.BotonSel') and form.BotonSel eq 'Aprobar' or form.BotonSel eq 'btnAprobar'){
         mensaje="";
         if(isDefined('form.chk')){
            listaID = listToArray(form.chk);
            for(i=1;i<=arrayLen(listaID);i++){
               mensaje = conciliaPagos.AprobarRegistro(listaID[i]);
               if(!isBoolean(mensaje))
                  throw(message="#(mensaje)#");
            }
         }
         else if(isDefined('form.PNRId')){
            mensaje = conciliaPagos.AprobarRegistro(form.PNRId);
            if(!isBoolean(mensaje))
               throw(message="#(mensaje)#");
         }
         location( "ConciliacionPagosNRef-Aprobador.cfm" );
      }
      

</cfscript>