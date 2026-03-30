<!---<cfdump var="#form#">
<cfabort> --->

<cfset varPosteo = true>
<cfif IsDefined("form.Cambio")>
<cfquery name="ValidaDAux" datasource="#session.DSN#">
    select *
    from EMetPar
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">
	and MetParID != <cfqueryparam value="#form.MetParID#" cfsqltype="cf_sql_numeric">
</cfquery>
<cfquery name="ValidaDAux2" datasource="#session.DSN#">
    select *
    from HEMetPar
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">
	and MetParID != <cfqueryparam value="#form.MetParID#" cfsqltype="cf_sql_numeric">
</cfquery>
</cfif>


<cfif IsDefined("form.Alta")>
<cfquery name="ValidaDoc1" datasource="#session.DSN#">
    select *
    from EMetPar
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">
</cfquery>
<cfquery name="ValidaDoc2" datasource="#session.DSN#">
    select *
    from HEMetPar
    where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">
</cfquery>
</cfif>

<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
	select Mcodigo
    from Empresas
    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="rsMes" datasource="#session.dsn#">
	select Pvalor as Mes from Parametros
    where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
    and Pcodigo =60
</cfquery>
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select Pvalor as Periodo from Parametros
    where  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
    and Pcodigo =50
</cfquery>

<cfif IsDefined('form.MetParID') and not isdefined("Form.chk")>
 <cfquery name="rsFormDet" datasource="#session.DSN#">
		Select  *
		from EMetPar emp
        	inner join DMetPar dmp
            on emp.Ecodigo = dmp.Ecodigo and emp.MetParID = dmp.MetParID
		where emp.MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
	</cfquery>

 <cfquery name="rsFormDet2" datasource="#session.DSN#">
		Select  *
		from EMetPar
		where MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
	</cfquery>

</cfif>

<cfset varMonedaL = rsMonedaLocal.Mcodigo>
<cfset cambioTotEnc = false>


 <cfif IsDefined("form.Cambio")> <!--- cambio encabezado --->
<cfset paso ="SI">

<cfif form.Documento eq ''>
	<script language="JavaScript1.2" type="text/javascript">
       alert('El campo Documento no puede estar en blanco');
    </script>
	<cfset paso ="NO">
</cfif>

<cfif form.Descripcion eq ''>
	<script language="JavaScript1.2" type="text/javascript">
       alert('El campo Descripcion no puede estar en blanco');
    </script>
	<cfset paso ="NO">
</cfif>
<cfif paso eq "SI">
  <cfif ValidaDAux.RecordCount gt 0 or ValidaDAux2.RecordCount gt 0>

<script language="JavaScript1.2" type="text/javascript">
alert('El Documento ya Existe, Verifica el Documento');
</script>

<cfelse>
	<cfquery name="update" datasource="#session.DSN#">
		update EMetPar
			set	Fecha=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(form.FechaCalculoMetPar,'dd/mm/yyyy')#">,
                Documento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">,
                Descripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
				BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">

		where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and MetParID = <cfqueryparam value="#form.MetParID#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>
<cfif rsFormDet.RecordCount gt 0>
	<cfquery name="updDetMetParDet" datasource="#session.dsn#">
		update DMetPar set
				Documento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">,
				Fecha=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(form.FechaCalculoMetPar,'dd/mm/yyyy')#">,
                Descripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">
		        where MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParId#">
	            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
</cfif>
</cfif>





	<cfset cambioTotEnc = true>

<cfelseif IsDefined("form.Baja")> <!--- Elimina Documento --->
	    <cfquery datasource="#session.dsn#">
			delete DMetPar
			where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and MetParID = <cfqueryparam value="#form.MetParID#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery datasource="#session.dsn#">
			delete EMetPar
			where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and MetParID = <cfqueryparam value="#form.MetParID#" cfsqltype="cf_sql_numeric">
		</cfquery>

<cfelseif IsDefined("form.Alta")>
<!--- Inserta Documento --->
<cfif ValidaDoc1.RecordCount gt 0 or ValidaDoc2.RecordCount gt 0>

<script language="JavaScript1.2" type="text/javascript">
alert('El Documento ya Existe, Verifica el Documento');
</script>

<cfelse>
<cftransaction>
		<cfquery name="insertEnc" datasource="#session.dsn#">
			insert into EMetPar (Ecodigo,  SNid, Fecha, Periodo, Mes, Documento, Descripcion, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaCalculoMetPar#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Periodo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.Mes#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)

			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertEnc">

	</cftransaction>
</cfif>


<!--- SENTENCIAS PARA EL DETALLE --->
<cfelseif IsDefined("form.AltaDet")> <!--- Inserta Detalle --->

<cfset capital1 = #form.Capital.replace(",","")# >
<cfset monto1 = #form.Monto.replace(",","")# >

<cftransaction>
    <cfquery name="insertDet" datasource="#session.dsn#">
		insert INTO DMetPar
			(MetParID,Ecodigo, Fecha, Periodo, Mes, Documento, Descripcion, Mcodigo, TC, Capital, pctjePart,
            	Monto, CCuentaCR, CCuentaDB, CFCuentaCR,CFCuentaDB, ArchSoporte,BMUsucodigo,NomArchSop)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParId#">,
        		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsFormDet2.Fecha#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Periodo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.Mes#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFormDet2.Documento#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFormDet2.Descripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MCodigo#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#form.TipoCambio#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#capital1#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.porcentajepar#" >,
                <cfqueryparam cfsqltype="cf_sql_float" value="#monto1#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfcuenta_ccuenta1#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfcuenta_ccuenta2#">,
                <cf_dbupload filefield="AFimagen" accept="image/*,text/*,application/*" datasource="#session.dsn#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFnombre#">)

    </cfquery>

</cftransaction>
	<cfset cambioTotEnc = true>

<cfelseif IsDefined("form.CambioDet")> <!--- Cambia Detalle --->

<cfset capital1 = #form.Capital.replace(",","")# >
<cfset monto1 = #form.Monto.replace(",","")# >

<cfif form.afnombre eq ''>
	<cfquery name="updDetMetPar" datasource="#session.dsn#">
		update DMetPar set
				Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.Mcodigo#">,
                TC=<cfqueryparam cfsqltype="cf_sql_float" value="#rsFormDet.TC#">,
				Capital=<cfqueryparam cfsqltype="cf_sql_float" value="#capital1#">,
				pctjePart=<cfqueryparam cfsqltype="cf_sql_float" value="#form.porcentajePar#" >,
                Monto=<cfqueryparam cfsqltype="cf_sql_float" value="#monto1#" >,
			<cfif form.Ccuenta1 gt 0>
				CCuentaCR=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta1#">,
			</cfif>
			<cfif form.Ccuenta2 gt 0>
				CCuentaDB=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta2#">,
			</cfif>
			<cfif form.cfcuenta_ccuenta1 gt 0>
				CFCuentaCR=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfcuenta_ccuenta1#">,
			</cfif>
			<cfif form.cfcuenta_ccuenta2 gt 0>
                CFCuentaDB=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfcuenta_ccuenta2#">,
			</cfif>
				BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usucodigo#">
		   where MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParId#">
	        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

<cfelse>
     <cfquery name="updDetMetPar2" datasource="#session.dsn#">
		update DMetPar set
				Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormDet.Mcodigo#">,
                TC=<cfqueryparam cfsqltype="cf_sql_float" value="#rsFormDet.TC#">,
				Capital=<cfqueryparam cfsqltype="cf_sql_float" value="#capital1#">,
				pctjePart=<cfqueryparam cfsqltype="cf_sql_float" value="#form.porcentajePar#" >,
                Monto=<cfqueryparam cfsqltype="cf_sql_float" value="#monto1#" >,
				<cfif form.Ccuenta1 gt 0>
				CCuentaCR=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta1#">,
			</cfif>
			<cfif form.Ccuenta2 gt 0>
				CCuentaDB=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta2#">,
			</cfif>
			<cfif form.cfcuenta_ccuenta1 gt 0>
				CFCuentaCR=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfcuenta_ccuenta1#">,
			</cfif>
			<cfif form.cfcuenta_ccuenta2 gt 0>
                CFCuentaDB=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfcuenta_ccuenta2#">,
			</cfif>
                ArchSoporte=<cf_dbupload filefield="AFimagen" accept="image/*,text/*,application/*" datasource="#session.dsn#">,
				BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usucodigo#">,
				NomArchSop=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFnombre#">
		   where MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParId#">
	        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

</cfif>

	<cfset cambioTotEnc = true>

<cfelseif IsDefined("form.BajaDet")> <!--- Elimina un detalle --->
	<cfquery datasource="#session.dsn#">
		delete DMetPar
		where MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfset cambioTotEnc = true>

<cfelseif IsDefined("form.Eliminar_ArchivoDet")> <!--- Elimina un detalle --->
	<cfquery datasource="#session.dsn#">
		update DMetPar
		set ArchSoporte = null,
		NomArchSop=null
		where MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfset cambioTotEnc = false>

<cfelseif (isdefined("Form.btnEliminar"))> <!--- Elimina --->
	<cfif (isdefined("Form.chk"))> <!--- Viene de la lista --->
		<cfset datos = ListToArray(Form.chk,",")>
		<cfset limite = ArrayLen(datos)>
        <cfloop from="1" to="#limite#" index="idx">
			<cftransaction>
                <cfquery datasource="#session.DSN#">
                    delete DMetPar
                        where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and MetParID = <cfqueryparam value="#datos[idx]#" cfsqltype="cf_sql_numeric">
                </cfquery>
                <cfquery datasource="#session.DSN#">
                    delete EMetPar
                        where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and MetParID = <cfqueryparam value="#datos[idx]#" cfsqltype="cf_sql_numeric">
                </cfquery>

            </cftransaction>
		</cfloop>
		<cfset cambioTotEnc = false>
	</cfif>

<cfelseif (isdefined("Form.btnAplicar"))>
<!--- Aplica Facturas --->

<cfif (isdefined("Form.chk"))>
		<cfset datos = ListToArray(Form.chk,",")>
        <cfset limite = ArrayLen(datos)>
		<cfloop from="1" to="#limite#" index="idx">
			<!--- Toma los valores para la Prefactura --->

            <cfquery name="rsApCont" datasource="#session.dsn#">
            	Select *
            	from EMetPar emp
        	    inner join DMetPar dmp on emp.Ecodigo = dmp.Ecodigo and emp.MetParID = dmp.MetParID
		        where emp.MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
            </cfquery>
<cfif  rsApCont.RecordCount gt 0 >
<cftransaction>
            <cfquery name="rsDMetP" datasource="#session.dsn#">
            	Select *
            	from DMetPar
		        where MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[idx]#">
            </cfquery>

       <!-- Insertamos los datos en los historicos -->
            <cfquery datasource="#session.dsn#">
            	insert into HEMetPar (MetParID,Ecodigo,SNid,Fecha,Periodo,Mes,Documento,Descripcion)
                values
                (<cfqueryparam value="#rsApCont.MetParId#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.Ecodigo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.SNid#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#rsApCont.Fecha#" cfsqltype="cf_sql_date">,
                 <cfqueryparam value="#rsApCont.Periodo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.Mes#" cfsqltype="cf_sql_integer">,
                  <cfqueryparam value="#rsApCont.Documento#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#rsApCont.Descripcion#" cfsqltype="cf_sql_varchar">)
            </cfquery>

<cfif rsApCont.NomArchSop eq ''>

            <cfquery datasource="#session.dsn#">
            	insert into HDMetPar (MetParID,Ecodigo,Fecha,Periodo,Mes,Documento,
            	Descripcion,Mcodigo,TC,Capital,pctjePart,Monto,CCuentaCR,CCuentaDB,CFCuentaCR,CFCuentaDB)
                values
                (<cfqueryparam value="#rsApCont.MetParId#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#rsApCont.Fecha#" cfsqltype="cf_sql_date">,
                 <cfqueryparam value="#rsApCont.Periodo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.Mes#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.Documento#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#rsApCont.Descripcion#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#rsApCont.Mcodigo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.TC#" cfsqltype="CF_SQL_FLOAT">,
                 <cfqueryparam value="#rsApCont.Capital#" cfsqltype="CF_SQL_FLOAT">,
                 <cfqueryparam value="#rsApCont.pctjePart#" cfsqltype="CF_SQL_FLOAT">,
                 <cfqueryparam value="#rsApCont.Monto#" cfsqltype="CF_SQL_FLOAT">,
                 <cfqueryparam value="#rsApCont.CCuentaCR#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.CCuentaDB#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.CFCuentaCR#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.CFCuentaDB#" cfsqltype="cf_sql_integer">)
            </cfquery>

<cfelse>
			 <cfquery datasource="#session.dsn#">
            	insert into HDMetPar (MetParID,Ecodigo,Fecha,Periodo,Mes,Documento,
            	Descripcion,Mcodigo,TC,Capital,pctjePart,Monto,CCuentaCR,CCuentaDB,CFCuentaCR,CFCuentaDB,ArchSoporte,NomArchSop)
                values
                (<cfqueryparam value="#rsApCont.MetParId#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#rsApCont.Fecha#" cfsqltype="cf_sql_date">,
                 <cfqueryparam value="#rsApCont.Periodo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.Mes#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.Documento#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#rsApCont.Descripcion#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#rsApCont.Mcodigo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.TC#" cfsqltype="CF_SQL_FLOAT">,
                 <cfqueryparam value="#rsApCont.Capital#" cfsqltype="CF_SQL_FLOAT">,
                 <cfqueryparam value="#rsApCont.pctjePart#" cfsqltype="CF_SQL_FLOAT">,
                 <cfqueryparam value="#rsApCont.Monto#" cfsqltype="CF_SQL_FLOAT">,
                 <cfqueryparam value="#rsApCont.CCuentaCR#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.CCuentaDB#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.CFCuentaCR#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.CFCuentaDB#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.ArchSoporte#" cfsqltype="CF_SQL_LONGVARBINARY">,
                 <cfqueryparam value="#rsApCont.NomArchSop#" cfsqltype="cf_sql_varchar">)
            </cfquery>
</cfif>
		<!--- Queries para registrar en  la Contabilidad --->
<cfinvoke
   component="sif.Componentes.Contabilidad"
   method="Nuevo_Asiento"
   returnvariable="Nuevo_AsientoRet">
    <cfinvokeargument name="Cconcepto" value="0"/>
   <cfinvokeargument name="Oorigen" value=" "/>
   <cfinvokeargument name="Eperiodo" value="#rsPeriodo.Periodo#"/>
   <cfinvokeargument name="Emes" value="#rsMes.Mes#"/>
   <cfinvokeargument name="Edocumento" value="0"/>
  </cfinvoke>
  <cfset referencia="MetPar#rsPeriodo.Periodo##rsMes.Mes#">
  <!-- Insertamos datos en EContables y DContables -->

		 <cfquery name="insertarC" datasource="#session.dsn#">
            	insert into EContables (Ecodigo,Cconcepto,Eperiodo,Emes,Edocumento,Efecha,
            	Edescripcion,Edocbase,Ereferencia,ECauxiliar,ECusuario,ECtipo,ECfechacreacion,
            	ECestado,ECreversible,BMUsucodigo,ECrecursivo,ECrecordarForm)
                values
                (<cfqueryparam value="#rsApCont.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsPeriodo.Periodo#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsMes.Mes#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#now()#" cfsqltype="CF_SQL_DATE">,
                 <cfqueryparam value="#rsApCont.Descripcion#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#rsApCont.Documento#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="S" cfsqltype="cf_sql_char">,
                 '#session.usulogin#',
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsApCont.Fecha#" cfsqltype="CF_SQL_DATE">,   <!--- Puede cambiar la variable --->
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,
                 #session.usucodigo#,0,0)
				<cf_dbidentity1 datasource="#session.DSN#">
            </cfquery>

	<!--- Obtenemos el Id de EContables --->
	<cf_dbidentity2 datasource="#session.DSN#" name="insertarC">
	<cfset IdContable = #insertarC.identity#>

 <cfset montLoc=rsDMetP.Monto/rsDMetP.TC>
     <!--- Insertamos DContables --->

           <cfquery name="InsDeb" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 1,
		 		 <cfqueryparam value="#rsApCont.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#rsPeriodo.Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#rsMes.Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#rsApCont.Descripcion#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#rsApCont.Documento#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'D',
                 <cfqueryparam value="#rsDMetP.CCuentaCR#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsDMetP.CFCuentaCR#" cfsqltype="cf_sql_integer">,
				  #montLoc#,
                 <cfqueryparam value="#rsDMetP.Monto#" cfsqltype="cf_sql_float">,
                 '#rsDMetP.Mcodigo#',#rsDMetP.TC#,#session.usucodigo#)
            </cfquery>

            <cfquery name="InsCred" datasource="#session.dsn#">
            	insert into DContables (IDcontable,Dlinea,Ecodigo,Cconcepto,Ocodigo,Eperiodo,Emes,
            	Edocumento,Ddescripcion,Ddocumento,Dreferencia,Dmovimiento,Ccuenta,CFcuenta,Doriginal,Dlocal,Mcodigo,Dtipocambio,BMUsucodigo)
                values
                (<cfqueryparam value="#IdContable#" cfsqltype="cf_sql_numeric">,
		 		 2,
		 		 <cfqueryparam value="#rsApCont.Ecodigo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value=0 cfsqltype="cf_sql_integer">,0,
		 		 <cfqueryparam value="#rsPeriodo.Periodo#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#rsMes.Mes#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#Nuevo_AsientoRet#" cfsqltype="cf_sql_integer">,
		 		 <cfqueryparam value="#rsApCont.Descripcion#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#rsApCont.Documento#" cfsqltype="cf_sql_varchar">,
                 <cfqueryparam value="#referencia#" cfsqltype="cf_sql_varchar">,
                 'C',
				 <cfqueryparam value="#rsDMetP.CCuentaDB#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#rsDMetP.CFCuentaDB#" cfsqltype="cf_sql_integer">,
        		 #montLoc#,
                 <cfqueryparam value="#rsDMetP.Monto#" cfsqltype="cf_sql_float">,
                 '#rsDMetP.Mcodigo#',#rsDMetP.TC#,#session.usucodigo#)
            </cfquery>


		<!--- Eliminamos las tablas --->
		<cfquery datasource="#session.dsn#">
			delete DMetPar
			where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and MetParID = <cfqueryparam value="#rsApCont.MetParId#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery datasource="#session.dsn#">
			delete EMetPar
			where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and MetParID = <cfqueryparam value="#rsApCont.MetParId#" cfsqltype="cf_sql_numeric">
		</cfquery>


</cftransaction>
<cfelse>
<script language="JavaScript1.2" type="text/javascript">
alert('El Documento no se puede Aplicar porque no tiene Detalle');
</script>
</cfif>

		</cfloop>
</cfif>
</cfif>



<form action="MetodoParticipacion.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Alta')>
		<cfif ValidaDoc1.RecordCount gt 0 or ValidaDoc2.RecordCount gt 0>
		<cfelse>
            <input name="MetParID" id="MetParID" type="hidden" value="#insertEnc.identity#">
        </cfif>
		<cfelseif isdefined('form.Nuevo') or isdefined('form.Baja')>
			<input name="btnNuevo" type="hidden" value="btnNuevo">
		<cfelse>
			<cfif IsDefined("form.CambioDet")>
	            <input name="MetParID" id="MetParID" type="hidden" value="#Form.MetParID#">

            <cfelseif IsDefined("form.AltaDet") OR isdefined("Form.NuevoDet") OR isdefined("Form.BajaDet") OR isdefined("Form.Cambio") or isdefined("Form.Eliminar_ArchivoDet") >
	            <input name="MetParID" id="MetParID" type="hidden" value="#Form.MetParID#">

			<cfelseif not isdefined('form.btnAplicar')>
	            <!---<input name="MetParID" id="MetParID" type="hidden" value="#insertEnc.identity#">--->
			</cfif>


		</cfif>
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>