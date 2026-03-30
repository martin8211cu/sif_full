
<cfinclude template="FnScripts.cfm">

<cfset ecodigo = session.ecodigo>

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
  order by id
</cfquery>


<cftransaction>
<!---    Validación del Archivo    --->
    <cfscript>
        /*
        //Chequear existencia de Números de Socio
        rsQRY = fnQuery ("select count(1) as CCheck from #table_name# a, SNegocios b where b.SNnumero = a.SNnumero and b.Ecodigo = #Ecodigo#");
        if(rsQRY.CCheck > 0){
            rsQRY = fnQuery ("select distinct a.SNnumero as Codigo from #table_name# a, SNegocios b where b.SNnumero = a.Snnumero");
            codigos = listToArray(ValueList(rsQRY.Codigo));
            for (i=1;i <= ArrayLen(codigos);i=i+1) {
                sbError ("FATAL", "El numero '#codigos[i]#' ya existe.");
            }
        }
        
        //Chequear existencia de Identificación de Socio
        rsQRY = fnQuery ("select count(1) as CCheck from #table_name# a, SNegocios b where b.SNidentificacion = a.SNidentificacion and b.Ecodigo = #Ecodigo#");
        if(rsQRY.CCheck > 0){
            rsQRY = fnQuery ("select distinct a.SNidentificacion as Codigo from #table_name# a, SNegocios b where b.SNidentificacion = a.SNidentificacion");
            codigos = listToArray(ValueList(rsQRY.Codigo));
            for (i=1;i LTE ArrayLen(codigos);i=i+1) {
                sbError ("FATAL", "La Identificacion '#codigos[i]#' ya existe.");
            }
        }	
        */
        /*Validar que el Numero de Socio no esté duplicado en el archivo */
        rsQRY = fnQuery ("select count(SNnumero) from #table_name# group by SNnumero having count(SNnumero) > 1");
        if(rsQRY.RecordCount > 0){
            rsQRY = fnQuery ("select SNnumero as Codigo, count(SNnumero) as conteo from #table_name# group by SNnumero having count(SNnumero) > 1");
            codigos = listToArray(ValueList(rsQRY.Codigo));
            for (i=1;i LTE ArrayLen(codigos);i=i+1) {
                sbError ("FATAL", "El numero de socio '#codigos[i]#' esta repetido en el archivo");
            }
        }

        /*Validar que la Identificacion de Socio no esté duplicado en el archivo */
        rsQRY = fnQuery ("select count(SNidentificacion) from #table_name# group by SNidentificacion having count(SNidentificacion) > 1");
        if(rsQRY.RecordCount > 0){
            rsQRY = fnQuery ("select SNidentificacion as Codigo, count(SNidentificacion) as conteo from #table_name# group by SNidentificacion having count(SNidentificacion) > 1");
            codigos = listToArray(ValueList(rsQRY.Codigo));
            for (i=1;i LTE ArrayLen(codigos);i=i+1) {
                sbError ("FATAL", "La Identificacion de socio '#codigos[i]#' esta repetido en el archivo");
            }
        }

        /* Valida que el codigo de Pais dado exista */
        rsQRY = fnQuery ("select count(1) as CCheck from #table_name# t where not exists ( select 1 from Pais p where t.Ppais = p.Ppais)");
        if(rsQRY.CCheck > 0){
            rsQRY = fnQuery ("select t.Ppais as Codigo from #table_name# t where not exists ( select 1 from Pais p where t.Ppais = p.Ppais)");
            codigos = listToArray(ValueList(rsQRY.Codigo));
            for (i=1;i LTE ArrayLen(codigos);i=i+1) {
                sbError ("FATAL", "El Codigo de Pais '#codigos[i]#' no existe.");
            }
        }

        
        /* Valida que las cuentas contables de CxC existan */
        rsQRY = fnQuery ("select count(1) as CCheck from #table_name# t where not exists ( select 1 from CContables c where t.CuentaCC = c.Cformato and c.Ecodigo = #ecodigo#) and isnull (t.CuentaCC, ' ') != ' '");
        //writedump(var='#rsQRY#' abort='true');
        if(rsQRY.CCheck > 0){
            rsQRY = fnQuery ("select t.CuentaCC as Codigo from #table_name# t where  not exists ( select 1 from CContables c where t.CuentaCC = c.Cformato and c.Ecodigo = #ecodigo#) and isnull (t.CuentaCC, ' ') != ' '");
            codigos = listToArray(ValueList(rsQRY.Codigo));
            for (i=1;i LTE ArrayLen(codigos);i=i+1) {
                sbError ("FATAL", "La cuenta contable de CxC '#codigos[i]#' no existe.");
            }
        }

        /* Valida que las cuentas contables de CxP existan */
        rsQRY = fnQuery ("select count(1) as CCheck from #table_name# t where (t.CuentaCP <> '00000000' and t.CuentaCP <> '') and not exists ( select 1 from CContables c where t.CuentaCP = c.Cformato and c.Ecodigo = #ecodigo#) and isnull (t.CuentaCC, ' ') != ' '");
        if(rsQRY.CCheck > 0){
            rsQRY = fnQuery ("select t.CuentaCP as Codigo from #table_name# t where not exists ( select 1 from CContables c where t.CuentaCP = c.Cformato and c.Ecodigo = #ecodigo#) and isnull (t.CuentaCC, ' ') != ' '");
            codigos = listToArray(ValueList(rsQRY.Codigo));
            for (i=1;i LTE ArrayLen(codigos);i=i+1) {
                sbError ("FATAL", "La cuenta contable de CxP '#codigos[i]#' no existe.");
            }
        }

        /* Valida que el codigo de Moneda dado exista */
        rsQRY = fnQuery (" select count(1) CCheck from #table_name# t where not exists ( select 1 from Monedas m where t.Moneda = m.Miso4217 and m.Ecodigo = #ecodigo#) and t.Moneda is not null");
        if(rsQRY.CCheck > 0){
            rsQRY = fnQuery ("select t.Moneda as Codigo from #table_name# t where not exists ( select 1 from Monedas m where t.Moneda = m.Miso4217 and m.Ecodigo = #ecodigo#) and t.Moneda is not null");
            codigos = listToArray(ValueList(rsQRY.Codigo));
            for (i=1;i LTE ArrayLen(codigos);i=i+1) {
                sbError ("FATAL", "El Codigo de Moneda '#codigos[i]#' no existe.");
            }
        }
        
        rsQRY = sbExecute ("select null as SNcodigo, null as id_direccion,null as Mcodigo, null as SNcuentacxc, null as SNcuentacxp, * into ##table_name5 from #table_name#");	
        
        /* Averiguar el proximo SNcodigo */
        NextSNcodigo = fnQuery ("select (isnull(max(SNcodigo),0) +1) as SNcodigo from SNegocios where Ecodigo = #ecodigo# and SNcodigo <> 9999");
        rsQRY = sbExecute ("declare @SNcodigo int = #NextSNcodigo.SNcodigo#; update ##table_name5 set SNcodigo = @SNcodigo, @SNcodigo = @SNcodigo + 1");
        
        /* Averiguar el proximo id_direccion */
        NextIDDireccion = fnQuery ("select (isnull(max(id_direccion),0) +1) as id_direccion from DireccionesSIF");
        rsQRY = sbExecute ("declare @id_direccion int = #NextIDDireccion.id_direccion#;  update ##table_name5 set id_direccion = @id_direccion, @id_direccion = @id_direccion + 1");	

        /* Obtiene el Mcodigo  */
        rsQRY = sbExecute ("update ##table_name5 set Mcodigo = m.Mcodigo from ##table_name5 t, Monedas m where m.Miso4217 = t.Moneda and m.Ecodigo = #ecodigo# and t.Moneda is not null");
        
        /* Obtiene la cuenta de CxC y CxP */
        rsQRY = sbExecute ("update ##table_name5 set SNcuentacxc = c.Ccuenta from ##table_name5 t, CContables c where c.Cformato = CuentaCC and c.Ecodigo = #ecodigo# and t.CuentaCC is not null");
        rsQRY = sbExecute ("update ##table_name5 set SNcuentacxp = c.Ccuenta from ##table_name5 t, CContables c where c.Cformato = CuentaCP and c.Ecodigo = #ecodigo# and t.CuentaCP is not null");

    </cfscript>

    <cfif ErrorCount() eq 0>
        <!--- Insertar Socios de Negocio --->
        <cfquery datasource="#session.dsn#">

            update b
                    set b.dist = a.disT,
                    b.TarjH = a.TarjH,
                    b.Mayor = a.Mayor
                 from SNegocios b, #table_name# a 
                 where b.SNnumero = a.SNnumero and b.Ecodigo = #Ecodigo#

            if not exists ( select 1 from ##table_name5 where SNcodigo is null ) begin
                set identity_insert DireccionesSIF on
                
                insert DireccionesSIF (id_direccion,Ppais, BMUsucodigo, BMfechamod,direccion1,direccion2,ciudad,estado,codPostal)
                    select a.id_direccion,a.Ppais, #ecodigo#, getDate(),a.SNdireccion1,a.SNdireccion2,a.SNciudad,a.SNestado,a.SNcodigopostal
                    from ##table_name5 a
                    where a.SNnumero not in (select b.SNnumero from #table_name# t, SNegocios b where b.SNnumero = t.SNnumero and b.Ecodigo = #Ecodigo#)
                set identity_insert DireccionesSIF off

                insert SNegocios (Ecodigo, SNcodigo, SNcodigoext, SNnombre, SNtiposocio, SNtelefono, SNFax, SNemail, SNtipo, 
                            SNvencompras, SNvenventas, SNdireccion, SNFecha,ESNid,Mcodigo,Ppais,SNnumero,SNidentificacion,SNidentificacion2,id_direccion,
                            SNcuentacxc,SNcuentacxp,disT,TarjH,Mayor,FechaNacimiento,SNFechaNacimiento)
                    select #ecodigo#, a.SNcodigo, a.SNcodigoext, a.SNnombre, ltrim(rtrim(a.SNtiposocio)), a.SNtelefono, a.SNFax, 
                            a.SNemail, ltrim(rtrim(a.SNtipo)), a.SNvencompras, a.SNvenventas, 
                            CONCAT(SUBSTRING(a.SNdireccion1,1,100),' ',SUBSTRING(a.SNdireccion2,1,25),' ',SUBSTRING(a.SNciudad,1,30),' ',SUBSTRING(a.SNestado,1,30),' ',SUBSTRING(a.SNcodigopostal,1,30))
                            , getDate(), isnull((select ESNid from EstadoSNegocios en where en.Ecodigo = #ecodigo#),1),
                            case when isnull(a.Mcodigo,' ') = ' ' then e.Mcodigo else convert(numeric,a.Mcodigo) end, a.Ppais,
                            concat('2-',right(concat('900000',cast(a.SNnumero as int)),6)),a.SNidentificacion, a.SNcodigoext, a.id_direccion,a.Sncuentacxc,a.SNcuentacxp
                            ,a.disT,a.TarjH,a.Mayor,a.FechaNacimiento,a.FechaNacimiento
                        from ##table_name5 a, Empresas e
                        where e.Ecodigo = #ecodigo#
                            and a.SNnumero not in (select b.SNnumero from #table_name# a, SNegocios b where b.SNnumero = a.SNnumero and b.Ecodigo = #Ecodigo#)

                insert SNDirecciones (id_direccion,Ecodigo, SNcodigo, SNDfacturacion, SNDenvio, SNDactivo, SNDlimiteFactura, SNid,
                            SNnombre,SNcodigoext,SNDcodigo)
                    select a.id_direccion,#ecodigo#, a.SNcodigo, 1, 1, 1, 0.00,s.SNid,CONCAT(SUBSTRING(a.SNdireccion1,1,90),' ',SUBSTRING(a.SNdireccion2,1,20),' ',SUBSTRING(a.SNciudad,1,30),' ',SUBSTRING(a.SNestado,1,30),' ',SUBSTRING(a.SNcodigopostal,1,30)) + ' - Principal',s.SNcodigoext,s.SNnumero + '-1'
                        from ##table_name5 a, SNegocios s
                        where a.SNcodigo = s.SNcodigo
                            and s.Ecodigo = #ecodigo#
                            and a.SNnumero not in (select b.SNnumero from #table_name# a, SNegocios b where b.SNnumero = a.SNnumero and b.Ecodigo = #Ecodigo#)
                update DireccionesSIF
                    set direccion1 = SNnombre
                    from DireccionesSIF a, SNDirecciones b
                    where a.id_direccion = b.id_direccion
                        and b.Ecodigo = #ecodigo#

               drop table ##table_name5
            end
        </cfquery>
    <cfelse>
        <cfset ERR = fnVerificaErrores()>
    </cfif>
</cftransaction>

<cffunction  name="ErrorCount">
    <cfquery name="rsSQL" datasource="#session.dsn#">
		select LVL, MSG 
		  from #Tabla_Error#
	</cfquery>
    <cfreturn rsSQL.recordCount>
</cffunction>

<!---
else{
            rsQRY = fnQuery ("select distinct a.SNnumero as Codigo from #table_name# a");
            codigos = listToArray(ValueList(rsQRY.Codigo));
            for (i=1;i LTE ArrayLen(codigos);i=i+1) {
                sbError ("FATAL", "Inserta '#codigos[i]#'");
            }
        }	

--->