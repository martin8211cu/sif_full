<cffunction name="insertParametro" >
	<cfargument name="parametro" type="string" required="yes">
	<cfargument name="descripcion" type="string" required="yes">
	<cfargument name="valor" type="string" required="yes">
	<cfargument name="modulo" type="string" required="yes">
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 1
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parametro#">
		</cfquery>

		<cfif rsExiste.RecordCount gt 0>
			<cfquery name="update" datasource="#session.DSN#">
				update Parametros
				set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.valor)#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parametro#">
			</cfquery>
		<cfelse>
			<cfquery name="insert" datasource="#session.DSN#">
				insert into Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parametro#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.modulo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.descripcion)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.valor)#"> )
			</cfquery>
		</cfif>
</cffunction>

<!--- 1. Mascara de Cuentas Contables --->
<cfquery name="rsExisteMascara" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=10
</cfquery>
<cfif rsExisteMascara.total gt 0>
	<cfquery name="insertMascara" datasource="#session.DSN#">
		update Parametros
		set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mascara#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 10
	</cfquery>
<cfelse>
	<cfquery name="insertMascara" datasource="#session.DSN#">
		insert into Parametros( Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 10,
				 'CO',
				 'Mscara de Cuentas Contables',
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.mascara#"> )
	</cfquery>
</cfif>


<!--- Conceptos Contables --->
<cfquery name="rsExisteCContableE" datasource="#session.DSN#">
	select count(1) as total
	from ConceptoContableE
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Cconcepto=0
</cfquery>
<cfif rsExisteCContableE.total eq 0 >
	<cfquery name="insertMascara" datasource="#session.DSN#">
		insert into ConceptoContableE ( Ecodigo, Cconcepto, Cdescripcion )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 0, 'General' )
	</cfquery>
</cfif>

<!--- Conceptos por Auxiliar Contable --->
<cfquery name="insertCContable" datasource="#session.DSN#">
	insert into ConceptoContable( Ecodigo, Oorigen, Cconcepto, Cdescripcion )
	select #session.Ecodigo#, Oorigen, 0, Odescripcion
	from Origenes
</cfquery>

<!--- Oficinas --->
<cfquery name="rsExisteOficina" datasource="#session.DSN#">
	select count(1) as total
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Ocodigo=0
</cfquery>
<cfif rsExisteOficina.total eq 0>
	<cfquery name="insertOficina" datasource="#session.DSN#">
		insert into Oficinas(Ecodigo, Ocodigo, Oficodigo, Odescripcion)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 0,
				 'Central',
				 'Oficina Central' )
	</cfquery>
</cfif>

<!--- Departamento --->
<cfquery name="rsExisteDpto" datasource="#session.DSN#">
	select count(1) as total
	from Departamentos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Dcodigo=0
</cfquery>
<cfif rsExisteDpto.total eq 0>
	<cfquery name="insertDpto" datasource="#session.DSN#">
		insert into Departamentos( Ecodigo, Dcodigo, Deptocodigo, Ddescripcion )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		         0,
				 'General',
				 'Departamento Contable' )
	</cfquery>
</cfif>

<!--- Socio de Negocios Generico --->
<cfquery name="minESNid" datasource="#session.dsn#">
	select min(ESNid) as ESNid
	from EstadoSNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif Len(minESNid.ESNid) EQ 0>
	<cfquery name="rsEstadoSN" datasource="#session.DSN#">
		insert into EstadoSNegocios (Ecodigo,ESNcodigo,ESNdescripcion,ESNfacturacion,BMUsucodigo)
		values(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				'1',
				'Activo',
				1,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsEstadoSN">
	<cfset EstadoID = rsEstadoSN.identity>
<cfelse>
	<cfset EstadoID = minESNid.ESNid>
</cfif>


<cfquery datasource="#session.dsn#" name="MonedaDeLaEmpresa">
	select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsExisteSocio" datasource="#session.DSN#">
	select count(1) as total
	from SNegocios
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and SNcodigo=9999
</cfquery>
<cfif rsExisteSocio.total eq 0>
	<cfquery name="insertSocio" datasource="#session.DSN#">
		insert into SNegocios ( Ecodigo, SNcodigo, SNnombre, SNFecha, SNnumero, SNidentificacion, SNtiposocio, SNtipo,
			ESNid , Mcodigo)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		 		 9999,
				 'Socio de Negocios Genrico',
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				 '999-9999',
				 '9999',
				 'A',
				 'F',
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#EstadoID#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#MonedaDeLaEmpresa.Mcodigo#"> )
	</cfquery>
</cfif>

<!--- Plan de Cuentas --->
<cfquery name="rsExistePlanCuentas" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=1
</cfquery>
<cfif rsExistePlanCuentas.total eq 0 >
	<cfquery name="insertPlanCuentas" datasource="#session.DSN#">
		insert into Parametros( Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		         1,
				 'AD',
				 'Usa Plan de Cuentas',
				 'N' )
	</cfquery>
<cfelse>
	<cfquery name="updatePlanCuentas" datasource="#session.DSN#">
		update Parametros
		set Pvalor = 'N'
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo=1
	</cfquery>
</cfif>

<!--- Primer Vencimientos --->
<cfquery name="rsExisteVenc1" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=310
</cfquery>
<cfif rsExisteVenc1.total eq 0 >
	<cfquery name="insertVenc1" datasource="#session.DSN#">
		insert into Parametros( Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 310,
				 'GN',
				 'Primer Vencimiento en Das',
				 '30' )
	</cfquery>
<cfelse>
	<cfquery name="updateVenc1" datasource="#session.DSN#">
		update Parametros
		set Pvalor = '30'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 310
	</cfquery>

</cfif>

<!--- Segundo Vencimientos --->
<cfquery name="rsExisteVenc2" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=320
</cfquery>
<cfif rsExisteVenc2.total eq 0 >
	<cfquery name="insertVenc2" datasource="#session.DSN#">
		insert into Parametros( Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 320,
				 'GN',
				 'Segundo Vencimiento en Das',
				 '60' )
	</cfquery>
<cfelse>
	<cfquery name="updateVenc2" datasource="#session.DSN#">
		update Parametros
		set Pvalor = '60'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 320
	</cfquery>

</cfif>

<!--- Tercer Vencimientos --->
<cfquery name="rsExisteVenc3" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=330
</cfquery>
<cfif rsExisteVenc3.total eq 0 >
	<cfquery name="insertVenc" datasource="#session.DSN#">
		insert into Parametros( Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 330,
				 'GN',
				 'Tercer Vencimiento en Das',
				 '90' )
	</cfquery>
<cfelse>
	<cfquery name="updateVenc" datasource="#session.DSN#">
		update Parametros
		set Pvalor = '90'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 330
	</cfquery>

</cfif>

<!--- Cuarto Vencimientos --->
<cfquery name="rsExisteVenc4" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=340
</cfquery>
<cfif rsExisteVenc4.total eq 0 >
	<cfquery name="insertVenc4" datasource="#session.DSN#">
		insert into Parametros( Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 340,
				 'GN',
				 'Cuarto Vencimiento en Das',
				 '120' )
	</cfquery>
<cfelse>
	<cfquery name="updateVenc4" datasource="#session.DSN#">
		update Parametros
		set Pvalor = '120'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 340
	</cfquery>
</cfif>

<!--- Forma de calculo de Impuestos --->
<cfquery name="rsExisteImpuesto" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 420
</cfquery>

<cfif rsExisteImpuesto.total eq 0>
	<cfquery name="insertImpuesto" datasource="#session.DSN#">
		insert into Parametros( Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 420,
				 'FA',
				 'Manejo del Descuento a nivel de Doc (0: Desc/Imp, 1: Imp/Desc.)',
				 '0' )
	</cfquery>
<cfelse>
	<cfquery name="updateImpuesto" datasource="#session.DSN#">
		update Parametros
		set Pvalor = '1'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 420
	</cfquery>
</cfif>

<!--- Forma de Contabilizar Descuento Documento --->
<cfquery name="rsContabilizaDescuentoDoc" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 421
</cfquery>

<cfif rsContabilizaDescuentoDoc.total eq 0>
	<cfquery name="insertImpuesto" datasource="#session.DSN#">
		insert into Parametros( Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 421,
				 'CC',
				 'Forma de Contabilizar Descuento Documento CxC (D=Cta Descuento, I=Diminuye Ingreso)',
				 'D' )
	</cfquery>
<cfelse>
	<cfquery name="updateImpuesto" datasource="#session.DSN#">
		update Parametros
		set Pvalor = 'D'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 421
	</cfquery>
</cfif>

<!--- TIPO DE TRANSACCIONES BANCOS - CHEQUES --->
<cfquery name="rsExisteCK" datasource="#session.DSN#">
	select count(1) as total
	from BTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and BTcodigo = 'CK'
</cfquery>
<cfif rsExisteCK.total eq 0 >
	<cfquery name="insertCK" datasource="#session.DSN#">
		insert into BTransacciones( Ecodigo, BTcodigo, BTdescripcion, BTtipo )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'CK',
				 'Cheques',
				 'C' )
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="insertCK">
</cfif>

<cfset BTid_TR = insertCK.identity >
<cfset BTid = BTid_TR >

<!--- TIPO DE TRANSACCIONES BANCOS - TRANSFERENCIAS --->
<cfquery name="rsExisteTR" datasource="#session.DSN#">
	select count(1) as total
	from BTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and BTcodigo = 'TR'
</cfquery>
<cfif rsExisteTR.total eq 0 >
	<cfquery name="insertTR" datasource="#session.DSN#">
		insert into BTransacciones( Ecodigo, BTcodigo, BTdescripcion, BTtipo )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'TR',
				 'Transferencias',
				 'D' )
	</cfquery>
</cfif>

<!--- TIPO DE TRANSACCIONES BANCOS - DEPOSITOS --->
<cfquery name="rsExisteDP" datasource="#session.DSN#">
	select count(1) as total
	from BTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and BTcodigo = 'DP'
</cfquery>
<cfif rsExisteDP.total eq 0 >
	<cfquery name="insertDP" datasource="#session.DSN#">
		insert into BTransacciones( Ecodigo, BTcodigo, BTdescripcion, BTtipo )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		 		 'DP',
				 'Depsitos',
				 'D' )
	</cfquery>
</cfif>

<!--- TIPO DE TRANSACCIONES BANCOS - TRANSFERENCIAS DE CREDITO  --->
<cfquery name="rsExisteTC" datasource="#session.DSN#">
	select count(1) as total
    from BTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and BTcodigo = 'TC'
</cfquery>
<cfif rsExisteTC.total eq 0 >
	<cfquery name="insertTC" datasource="#session.DSN#">
		insert into BTransacciones( Ecodigo, BTcodigo, BTdescripcion, BTtipo )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		 		 'TC',
				 'Transferencias de Crdito',
				 'C' )
	</cfquery>
</cfif>

<!--- TIPO DE TRANSACCIONES BANCOS - TRANSFERENCIAS DE DEBITO  --->
<cfquery name="rsExisteTD" datasource="#session.DSN#">
	select count(1) as total
	from BTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and BTcodigo = 'TD'
</cfquery>
<cfif rsExisteTD.total eq 0 >
	<cfquery name="insertTD" datasource="#session.DSN#">
		insert into BTransacciones( Ecodigo, BTcodigo, BTdescripcion, BTtipo )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		 		 'TD',
				 'Transferencias de Dbito',
				 'D' )
	</cfquery>
</cfif>

<!--- Tipos de TRansacciones CxC - FC --->
<cfquery name="rsExisteTRCCFC" datasource="#session.DSN#">
	select count(1) as total
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and CCTcodigo = 'FC'
</cfquery>
<cfif rsExisteTRCCFC.total eq 0 >
	<cfquery name="insertTRCCFC" datasource="#session.DSN#">
		insert into CCTransacciones( Ecodigo, CCTcodigo, CCTdescripcion, CCTtipo, CCTpago  )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'FC',
				 'Facturas de Crdito',
				 'D',
				  0 )
	</cfquery>
</cfif>

<!--- Tipos de TRansacciones CxC - NC--->
<cfquery name="rsExisteTRCCNC" datasource="#session.DSN#">
	select count(1) as total
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and CCTcodigo = 'NC'
</cfquery>
<cfif rsExisteTRCCNC.total eq 0 >
	<cfquery name="insertTRCCNC" datasource="#session.DSN#">
		insert into CCTransacciones( Ecodigo, CCTcodigo, CCTdescripcion, CCTtipo, CCTpago )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		    	 'NC',
				 'Notas de Crdito',
				 'C',
				 0 )
	</cfquery>
</cfif>

<!--- Tipos de TRansacciones CxC - ND--->
<cfquery name="rsExisteTRCCND" datasource="#session.DSN#">
	select count(1) as total
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and CCTcodigo = 'ND'
</cfquery>
<cfif rsExisteTRCCND.total eq 0 >
	<cfquery name="insertTRCCND" datasource="#session.DSN#">
		insert into CCTransacciones( Ecodigo, CCTcodigo, CCTdescripcion, CCTtipo, CCTpago )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'ND',
				 'Notas de Dbito',
				 'D',
				  0 )
	</cfquery>
</cfif>

<!--- Tipos de TRansacciones CxC - RE--->
<cfquery name="rsExisteTRCCRE" datasource="#session.DSN#">
	select count(1) as total
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and CCTcodigo = 'RE'
</cfquery>
<cfif rsExisteTRCCRE.total eq 0 >
	<cfquery name="insertTRCCRE" datasource="#session.DSN#">
		insert into CCTransacciones( Ecodigo, CCTcodigo, CCTdescripcion, CCTtipo, CCTpago, BTid, CCTcktr )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'RE',
				 'Recibo de Pago',
				 'C',
				 1,
 				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#BTid_TR#">,
				 'C' )
	</cfquery>
</cfif>

<!--- Tipos de TRansacciones CxC - FA--->
<cfquery name="rsExisteTRCCFA" datasource="#session.DSN#">
	select count(1) as total
    from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and CCTcodigo = 'FA'
</cfquery>
<cfif rsExisteTRCCFA.total eq 0 >
	<cfquery name="insertTRCCFA" datasource="#session.DSN#">
		insert into CCTransacciones( Ecodigo, CCTcodigo, CCTdescripcion, CCTtipo, CCTvencim )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'FA',
				 'Facturas de Contado',
				 'D',
				 -1 )
	</cfquery>
</cfif>

<!--- Tipos de TRansacciones CxP - FC--->
<cfquery name="rsExisteTRCPFC" datasource="#session.DSN#">
	select count(1) as total
	from CPTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and CPTcodigo='FC'
</cfquery>
<cfif rsExisteTRCPFC.total eq 0 >
	<cfquery name="insertTRCPFC" datasource="#session.DSN#">
		insert into CPTransacciones( Ecodigo, CPTcodigo, CPTdescripcion, CPTtipo, CPTpago, CPTafectacostoventas, CPTnoflujoefe )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'FC',
				 'Facturas de Crdito',
				 'C',
				 0,
				 0,
				 0 )
	</cfquery>
</cfif>

<!--- Tipos de TRansacciones CxP - NC--->
<cfquery name="rsExisteTRCPNC" datasource="#session.DSN#">
	select count(1) as total
	from CPTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and CPTcodigo = 'NC'
</cfquery>
<cfif rsExisteTRCPNC.total eq 0 >
	<cfquery name="insertTRCPNC" datasource="#session.DSN#">
		insert into CPTransacciones( Ecodigo, CPTcodigo, CPTdescripcion, CPTtipo, CPTpago, CPTafectacostoventas, CPTnoflujoefe   )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'NC',
				 'Notas de Crdito',
				 'D',
				  0,0,0)
	</cfquery>
</cfif>

<!--- Tipos de TRansacciones CxP - ND--->
<cfquery name="rsExisteTRCPND" datasource="#session.DSN#">
	select count(1) as total
	from CPTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CPTcodigo = 'ND'
</cfquery>
<cfif rsExisteTRCPND.total eq 0 >
	<cfquery name="insertTRCPND" datasource="#session.DSN#">
		insert into CPTransacciones( Ecodigo, CPTcodigo, CPTdescripcion, CPTtipo, CPTpago, CPTafectacostoventas, CPTnoflujoefe )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		 		 'ND',
				 'Notas de Dbito',
				 'C',
				  0,
				  0,
				  0)
	</cfquery>
</cfif>

<!--- Tipos de TRansacciones CxP - RE--->
<cfquery name="rsExisteTRCPRE" datasource="#session.DSN#">
	select count(1) as total
	from CPTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and CPTcodigo = 'RE'
</cfquery>
<cfif rsExisteTRCPRE.total eq 0 >
	<cfquery name="insertTRCPRE" datasource="#session.DSN#">
		insert into CPTransacciones( Ecodigo, CPTcodigo, CPTdescripcion, CPTtipo, CPTpago, BTid, CPTcktr, CPTafectacostoventas, CPTnoflujoefe  )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'RE',
				 'Recibo de Pago',
				 'D',
				 1,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#BTid_TR#">,
				 'C',
				 0,
				 0 )
	</cfquery>
</cfif>

<!--- Conceptos de facturacion CxC --->
<cfquery name="rsExisteConceptoCC" datasource="#session.DSN#">
	select count(1) as total
	from Conceptos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Ccodigo = 'VENTA'
</cfquery>
<cfif rsExisteConceptoCC.total eq 0 >
	<cfquery name="insertConceptoCC" datasource="#session.DSN#">
		insert into Conceptos(Ecodigo, Ccodigo, Cdescripcion, Ctipo,CexcostosAuto)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'VENTA',
				 'Ventas',
				 'I' ,0)
	</cfquery>
</cfif>

<cfquery name="rsExisteConceptoCP" datasource="#session.DSN#">
	select count(1) as total
	from Conceptos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and Ccodigo = 'COMPRA'
</cfquery>
<cfif rsExisteConceptoCP.total eq 0 >
	<cfquery name="insertConceptoCP" datasource="#session.DSN#">
		insert into Conceptos(Ecodigo, Ccodigo, Cdescripcion, Ctipo,CexcostosAuto)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'COMPRA',
				 'Compras',
				 'G',0 )
	</cfquery>
</cfif>

<!--- Impuestos --->
<cfset impFormato = ''>

<cfif form.WTCid eq 1 >
	<cfset impFormato = '2000-0001-0004' >
<cfelse>
	<cfset impFormato = '2000-0001-0004' >
</cfif>

<cfquery name="rsCuentaImp" datasource="#session.DSN#">
	select Ccuenta
	from CContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#impFormato#">
</cfquery>

<cfif rsCuentaImp.RecordCount gt 0 and len(trim(rsCuentaImp.Ccuenta)) >
	<cfquery name="rsImpuestos" datasource="#session.DSN#">
		select count(1) as total
		from Impuestos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Icodigo = 'IE'
	</cfquery>
	<cfif rsImpuestos.total eq 0>

		<cfquery name="rsImpuestos" datasource="#session.DSN#">
			insert into Impuestos( Ecodigo, Icodigo, Idescripcion, Iporcentaje, Ccuenta, Usucodigo, Ifecha )
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'IE',
				 'Exento de Impuestos',
				 0,
				 <cfif form.WTCid eq 0 >
				 	<cfif len(trim(rsCcuentaImp.Ccuenta)) >
					 	<cfdump var="#sdlslsd#">
					 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaImp.Ccuenta#">
					<cfelse>
						null
					</cfif>
				 <cfelse>
					null
				 </cfif>,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> )
		</cfquery>
	</cfif>
</cfif>

<!--- Almacn, llave es un identity --->
<cfquery name="insertAlmacen" datasource="#session.DSN#">
	insert into Almacen ( Ecodigo, Almcodigo, Ocodigo, Dcodigo, Bdescripcion )
	values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			'ALM001',
			0,
			0,
			'Almacn Central' )
</cfquery>

<!--- Unidades --->
<cfquery name="rsExisteUnidades" datasource="#session.DSN#">
	select count(1) as total
	from Unidades
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Ucodigo = 'UNI'
</cfquery>
<cfif rsExisteUnidades.total eq 0 >
	<cfquery name="insertUnidades" datasource="#session.DSN#">
		insert into Unidades( Ecodigo, Ucodigo, Udescripcion, Uequivalencia )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 'UNI',
				 'Unidad',
				 1 )
	</cfquery>
</cfif>

<!--- Clasificaciones --->
<cfquery name="rsExisteClasificacion" datasource="#session.DSN#">
	select count(1) as total
	from Clasificaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Ccodigo = 0
</cfquery>
<cfif rsExisteClasificacion.total eq 0 >
	<cfquery name="insertClasificacion" datasource="#session.DSN#">
		insert into Clasificaciones(Ecodigo, Ccodigo, Ccodigoclas, Cdescripcion)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 0,
				 'CLA-0',
				 'General' )
	</cfquery>
</cfif>

<!--- Parametros de operacion --->
<cfquery name="rsExisteParametro160" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 160
</cfquery>

<cfif rsExisteParametro160.total eq 0>
	<cfquery name="insertParametro160" datasource="#session.DSN#">
		insert into Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 160,
				 'MB',
				 'Tipo de Mov. Origen Transferencias Bancarias',
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#BTid#">
			   )
	</cfquery>
<cfelse>
	<cfquery name="updateParametro160" datasource="#session.DSN#">
		update Parametros
		set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#BTid#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 160
	</cfquery>
</cfif>

<!--- Parametro 170 --->
<cfquery name="rsTranDeposito" datasource="#session.DSN#">
	select BTid
	from BTransacciones
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and BTcodigo = 'DP'
</cfquery>
<cfquery name="rsExisteParametro170" datasource="#session.DSN#">
	select count(1) as total
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 170
</cfquery>
<cfif rsExisteParametro170.total eq 0>
	<cfquery name="insertParametro170" datasource="#session.DSN#">
		insert into Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 170,
				 'MB',
				 'Tipo de Mov. Destino Transferencias Bancarias',
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTranDeposito.BTid#">
			   )
	</cfquery>
<cfelse>
	<cfquery name="updateParametro170" datasource="#session.DSN#">
		update Parametros
		set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTranDeposito.BTid#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 170
	</cfquery>
</cfif>

<cfset insertParametro('210','Transaccin de Pagos CxC','RE','CC') >
<cfset insertParametro('220','Transaccin de Pagos Cxp','RE','CP') >
