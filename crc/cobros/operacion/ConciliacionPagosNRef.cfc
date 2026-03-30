component{
    remote any function validaExistencia(string fecha, string referencia, numeric monto) returnformat="JSON" {
        arguments.fecha=dateFormat(createDate(mid(arguments.fecha,7,4), mid(arguments.fecha,4,2), mid(arguments.fecha,1,2)), "yyyy-mm-dd");
        valida = queryExecute("select PNRId, PNRGuardado, PNREnRevision, PNRAplicado
                    from PagosNoReferenciados 
                    where Ecodigo = :Ecodigo
                    and PNRFecha = :PNRFecha
                    and PNRReferencias = :PNRReferencias
                    and PNRMonto = :PNRMonto", 
                    {Ecodigo = "#session.Ecodigo#",
                    PNRFecha = "#arguments.fecha#",
                    PNRReferencias = "#replace(arguments.referencia, ' ', '', 'all')#",
                    PNRMonto = "#arguments.monto#"}, 
                    {datasource = "#session.DSN#"}
                );
        if(valida.RecordCount eq 0){
            return serializeJSON({message: "No éxiste ningún registro con esos datos"},true);
        } else {
            if(valida.PNRAplicado eq 1){
                return serializeJSON({message:'El registro ya está aplicado'},true);
            } else if(valida.PNREnRevision eq 1){
                return serializeJSON({message:'El registro ya está en revisión'},true);
            } else if(valida.PNRGuardado eq 1){
                return serializeJSON({message: "Ya éxiste un registro con esos datos"},true);
            } else {
                //update value PNRGuardado to 1 
                queryExecute("update PagosNoReferenciados
                    set PNRGuardado = 1
                    where Ecodigo = :Ecodigo
                    and PNRId = :PNRId",
                    {Ecodigo = "#session.Ecodigo#",
                    PNRId = "#valida.PNRId#"},
                    {datasource = "#session.DSN#"});
                return serializeJSON(valida.PNRId,true);
            }
            
        }
    }

    remote any function EliminarRegistro(numeric PNRId) returnformat="JSON"{
        try{
            queryExecute("update PagosNoReferenciados
                    set PNRGuardado = 0,
                    PNREnRevision = 0,
                    PNRAplicado = 0,
                    BMFecha = GETDATE(),
                    PNRCuenta = NULL
                    where Ecodigo = :Ecodigo
                    and PNRId = :PNRId",
                    {Ecodigo = "#session.Ecodigo#",
                    PNRId = "#Arguments.PNRId#"},
                    {datasource = "#session.DSN#"});
            return serializeJSON({message: "Registro eliminado con éxito"},true);
        } catch (any e){
            return serializeJSON({message: "Error al eliminar el registro"},true);
        }
    }

    remote any function RechazarRegistro(numeric PNRId) returnformat="JSON"{
        try{
            queryExecute("update PagosNoReferenciados
                    set PNRGuardado = 1,
                    PNREnRevision = 0,
                    PNRAplicado = 0,
                    BMFecha = GETDATE()
                    where Ecodigo = :Ecodigo
                    and PNRId = :PNRId",
                    {Ecodigo = "#session.Ecodigo#",
                    PNRId = "#Arguments.PNRId#"},
                    {datasource = "#session.DSN#"});
            return serializeJSON({message: "Registro rechazado con éxito"},true);
        } catch (any e){
            return serializeJSON({message: "Error al rechazar el registro"},true);
        }
    }

    remote any function ActualizaRegistro(numeric PNRId, numeric idCuenta) returnformat="JSON"{
        try{
            queryExecute("update PagosNoReferenciados
                    set PNRCuenta = :PNRCuenta,
                    BMFecha = GETDATE(),
                    BMusuario = :BMusuario
                    where Ecodigo = :Ecodigo
                    and PNRId = :PNRId",
                    {Ecodigo = "#session.Ecodigo#",
                    PNRId = "#Arguments.PNRId#",
                    PNRCuenta = "#idCuenta#",
                    BMusuario = "#session.Usucodigo#"},
                    {datasource = "#session.DSN#"});
            return serializeJSON({message: "La cuenta se ha guardado con éxito"},true);
        } catch (any e){
            writeDump(var=e);
            return serializeJSON({message: "Error al actualizar la cuenta"},true);
        }
    }

    remote any function AplicaRegistro(numeric PNRId) returnformat="JSON"{
        if(arrayIsEmpty(obtieneCuenta(PNRId))){
            return serializeJSON({message: "No se ha actualizado la cuenta"},true);
        }
        try{
            queryExecute("update PagosNoReferenciados
                    set PNRGuardado = 1,
                    PNREnRevision = 1,
                    PNRAplicado = 0,
                    BMFecha = GETDATE(),
                    BMusuario = :BMusuario
                    where Ecodigo = :Ecodigo
                    and PNRId = :PNRId",
                    {Ecodigo = "#session.Ecodigo#",
                    PNRId = "#Arguments.PNRId#",
                    BMusuario = "#session.Usucodigo#"},
                    {datasource = "#session.DSN#"});
            return serializeJSON({message: "Registro enviado a aprobar con éxito"},true);
        } catch (any e){
            return serializeJSON({message: "Error al enviar a aprobar el registro"},true);
        }
    }

    remote any function AprobarRegistro(numeric PNRId) returnformat="JSON"{
        pagos =  [];
        pago = StructNew();
        rsDatos = queryExecute("select c.Numero, p.PNRId,p.Ecodigo,p.FCid,p.CCTcodigo,p.CFid,p.Mcodigo,p.TCambio,p.FATid,p.id_zona,p.PNRReferencias,p.PNRMonto,p.PNRFecha,p.PNRCuenta
                from PagosNoReferenciados p
                inner join CRCCuentas c
                on p.PNRCuenta = c.id
                and p.Ecodigo = c.Ecodigo
                where p.Ecodigo = :Ecodigo
                and p.PNRId = :PNRId",
                {Ecodigo = "#session.Ecodigo#",
                PNRId = "#Arguments.PNRId#"},
                {datasource = "#session.DSN#"});
        if(rsDatos.RecordCount eq 0){
            return serializeJSON({message: "No se encontraron datos"},true);
        }
        pago.cuenta = rsDatos.Numero;
        pago.fecha = rsDatos.PNRFecha;
        pago.monto = rsDatos.PNRMonto;
        arrayAppend(pagos, pago);

        datosForm = StructNew();
        datosForm.Id_Caja = rsDatos.FCid;
        datosForm.CCTcodigo = rsDatos.CCTcodigo;
        datosForm.CFid = rsDatos.CFid;
        datosForm.Mcodigo = rsDatos.Mcodigo;
        datosForm.TCambio = rsDatos.TCambio;
        datosForm.Id_Tarjeta = rsDatos.FATid;
        datosForm.Id_Zona = rsDatos.id_zona;

        transaction{
            try{
                CRCPagosExt = createObject("component","crc.Componentes.pago.CRCImporadorPagos");
                result = CRCPagosExt.ImportarPagosExternos(pagos, datosForm, pago.monto);
                errores = listToArray(result,'¬');
            } catch (any e){
                return serializeJSON({message: "Error al aplicar el registro#e#"},true);
            }
        }

        if(arrayLen(errores) gt 0){
            return serializeJSON({message: errores[2]},true);
        }else{
            queryExecute("update PagosNoReferenciados
                set PNRGuardado = 1,
                PNREnRevision = 1,
                PNRAplicado = 1,
                BMusuarioAprobador = :BMusuario,
                BMFechaAprobado = GETDATE()
                where Ecodigo = :Ecodigo
                and PNRId = :PNRId",
                {Ecodigo = "#session.Ecodigo#",
                PNRId = "#Arguments.PNRId#",
                BMusuario = "#session.Usucodigo#"},
                {datasource = "#session.DSN#"});
            return serializeJSON(1,true);
        } 
    }

    public function obtieneCuenta(numeric PNRId){
        rsGetCuenta = queryExecute("select sn.SNid , c.id as ID_cta ,
	                	sn.SNidentificacion , sn.SNnombre , c.Numero , 
	                	Tipo = case 
	                			when Tipo = 'D' then 'Distribuidor'
	                			when Tipo = 'TC' then 'Tarjeta de Credito'
	                			when Tipo = 'TM' then 'Tarjeta Mayorista' 
	                	end
	                from CRCCuentas c 
	                inner join SNegocios sn on sn.SNid = c.SNegociosSNid 
                    inner join PagosNoReferenciados p on p.PNRCuenta = c.id
                    and p.Ecodigo = c.Ecodigo
                    where c.Ecodigo = :Ecodigo
                    and p.PNRId = :PNRId",
                    {Ecodigo = "#session.Ecodigo#",
                    PNRId = "#Arguments.PNRId#"},
                    {datasource = "#session.DSN#"});
        if(rsGetCuenta.RecordCount eq 0){
            return [];
        }else{
            return [rsGetCuenta.ID_cta,rsGetCuenta.Numero,rsGetCuenta.SNnombre,rsGetCuenta.Tipo];
        }
    }

    public function obtieneDatosLista(numeric guardado, numeric enRevision, numeric aplicado){
        rsGetData = queryExecute("select p.PNRId, p.PNRFecha, p.PNRReferencias, p.PNRCuenta, p.PNRMonto, sn.SNnombre, c.Numero
                    from PagosNoReferenciados p
                    left join CRCCuentas c 
                    on p.PNRCuenta = c.id
                    and p.Ecodigo = c.Ecodigo
	                left join SNegocios sn 
                    on sn.SNid = c.SNegociosSNid 
                    and sn.Ecodigo = c.Ecodigo
                    where p.Ecodigo = :Ecodigo
                    and p.PNRGuardado = :guardado
                    and	p.PNREnRevision = :enRevision
                    and	p.PNRAplicado = :aplicado",
                    {Ecodigo = "#session.Ecodigo#",
                    guardado = "#Arguments.guardado#",
                    enRevision = "#Arguments.enRevision#",
                    aplicado = "#Arguments.aplicado#"},
                    {datasource = "#session.DSN#"});
        return rsGetData;
    }
}