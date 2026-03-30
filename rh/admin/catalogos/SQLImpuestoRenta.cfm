<!--- 
Funcionamineto del Nuevo para este Archivo:
	En modo Alta viene definido Form.Nuevo, entonces no pasa de la primera línea de consultas  y se va directo al form,
		donde no pasa de la primera línea y se va directo al body donde hace submit y se va sin nada.
	En modo Cambio pueden ocurrir 2 nuevos: el del Encabezado y el del detalle.
		El del Encabezado sucede por defecto, porque no viene definido el Forom.Nuevo, entra en las consultas pone los 
		modos por defecto  y estos son los que se necesitan para esta acción, y al llegar al form define lo que necesita 
		el IR y al llegar a preguntar por Form.ENuevo que si viene se detiene y no define más.
		El del detalle requiere definir el modo del encabezado en cambio para que no se pierda, esto se hace al final de 
		las consultas.
	Se Agregaton un encabezado yb un datalle más que también son hijos del IR, estos son ConceptoDeduc y DConceptoDeduc, 
		el funcionamiento de estos 2 es exactamente igual a EIR y DIR. Aquí la variable CLAVE es frame, dependiendo de esta
		variable el funcionamiento de este SQL es para EIR y DIR o para CD y DCD
	Vocabulario:
		IR  = Tabla ImpuestoRenta en BD sifcontrol
		EIR = Tabla EImpuestoRenta en BD sifcontrol
		DIR = Tabla DImpuestoRenta en BD sifcontrol
		CD  = Tabla ConceptoDeduc en BD sifcontrol
		DCD = Tabla DConceptoDeduc en BD sifcontrol
--->
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="Error_El_codigo_del_Impuesto_ya_existe_Proceso_Cancelado" default="Error, El código del Impuesto ya existe, Proceso Cancelado!" returnvariable="MG_CodigoYaExiste" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->


<cfif not isDefined("Form.Nuevo")>
	<!--- Modos de Regreso a la Pantalla --->
	<cfset modo = "CAMBIO">
	<cfset emodo = "ALTA">
	<cfset dmodo = "ALTA">		
	
	<!--- Alta --->
	<cfif Form.Accion eq "Alta">
		<!--- Verifica la existencia del Código --->
		<cfquery name="rs1" datasource="sifcontrol">
			select 1
			from ImpuestoRenta 
			where IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>
		<cfif rs1.RecordCount GT 0>
			<cf_throw message="#MG_CodigoYaExiste#" errorcode="2150">
		</cfif>
		<!--- Da de alta el nuevo impuesto --->
		<cfquery name="rs" datasource="sifcontrol">
			Insert into ImpuestoRenta(IRcodigo, IRdescripcion, IRfactormeses, IRCreditoAntes,IRTipoPeriodo)
			values(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.IRfactormeses#">,
				<cfif isdefined("Form.IRCreditoAntes")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">)
		</cfquery>

	<!--- Cambio --->
	<cfelseif Form.Accion eq "Cambio">
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "ImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.IRtimestamp#"
			field1 = "IRcodigo"
			type1 = "char"
			value1 = "#form.IRcodigo#">

		<cfquery name="rs" datasource="sifcontrol">
			update ImpuestoRenta
			set IRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
			IRcodigoPadre=<cfif len(trim(Form.IRcodigoPadre))><cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigoPadre#"><cfelse>null</cfif>,
			IRfactormeses=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IRfactormeses#">,
			IRCreditoAntes=<cfif isdefined("Form.IRCreditoAntes")>1<cfelse>0</cfif>,
			IRTipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>
	
	<!--- Baja --->
	<cfelseif Form.Accion eq "Baja">
		<!--- Borra Detalles de Deducciones --->
		<cfquery name="rs" datasource="sifcontrol">
			delete from DConceptoDeduc
			where CDid in 	(
							select CDid from ConceptoDeduc
							where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
							)
		</cfquery>
		<!--- Borra Deducciones --->
		<cfquery name="rs" datasource="sifcontrol">
			delete from ConceptoDeduc
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>
		<!--- Borra Detalles de Impuesto --->
		<cfquery name="rs" datasource="sifcontrol">
			delete from DImpuestoRenta
			where EIRid in 	(select EIRid from EImpuestoRenta
							where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">)
		</cfquery>	
		<!--- Borra Detalles de Impuesto --->
		<cfquery name="rs" datasource="sifcontrol">
			delete from EImpuestoRenta
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>
		<!--- Borra Impuesto --->
		<cfquery name="rs" datasource="sifcontrol">
			delete from ImpuestoRenta
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>
		<cfset modo = 'ALTA'>
	
	<!--- Alta Detlles --->
	<cfelseif Form.frame eq "IR" and Form.Accion eq "EAlta">
		<!--- Actualiza Encabezado --->
		<cf_dbtimestamp 
				datasource = "sifcontrol"
				table = "ImpuestoRenta"
				redirect = "ImpuestoRenta.cfm"
				timestamp = "#form.IRtimestamp#"
				field1 = "IRcodigo"
				type1 = "char"
				value1 = "#form.IRcodigo#">
		<cftransaction>
			<cfquery name="rsUpd" datasource="sifcontrol">
				update ImpuestoRenta
					set IRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
					IRcodigoPadre=<cfif len(trim(Form.IRcodigoPadre))><cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigoPadre#"><cfelse>null</cfif>,
					IRfactormeses=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.IRfactormeses#">,
					IRCreditoAntes=<cfif isdefined("Form.IRCreditoAntes")>1<cfelse>0</cfif>,
					IRTipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">
				where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
			</cfquery>

			<!--- Inserta Nuevo Detalle --->
			<cfquery name="rsIns" datasource="sifcontrol">
				Insert into EImpuestoRenta(IRcodigo, EIRdesde, EIRhasta, EIRestado)
				values(
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EIRdesde)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EIRhasta)#">,
					0
				)
				<cf_dbidentity1 datasource="sifcontrol">
			</cfquery>
			<cf_dbidentity2 datasource="sifcontrol" name="rsIns">

			<!--- Obtiene el Detalle Anterior --->
			<cfquery name="rsAnterior" datasource="sifcontrol">
				select a.EIRid
				from EImpuestoRenta a 
				where a.EIRdesde = (select max(EIRdesde) 
									from EImpuestoRenta 
									where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
									and EIRdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EIRdesde)#">)
					and a.IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">				
			</cfquery>
			<!--- Si ya había un detalle caduca, para poner en vigencia el nuevo --->
			<cfif rsAnterior.RecordCount NEQ 0>
				<!--- Caduca el detalle anterior --->
				<cfset Fhasta=DateAdd("d", -1, LSParseDateTime(Form.EIRdesde))>
				<cfquery name="rsUpd2" datasource="sifcontrol">
					update EImpuestoRenta
					set EIRhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
					where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnterior.EIRid#">
				</cfquery>
				<!--- Poner en vigencia el nuevo detalle --->
				<cfquery name="rsIns2" datasource="sifcontrol">
					insert into DConceptoDeduc 
						(CDid, EIRid, DCDvalor, esporcentaje, Dfamiliar)
					select 
						CDid, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIns.identity#">, 
						DCDvalor,
						<cfif isdefined("form.esporcentaje")>1<cfelse>0</cfif>
						,<cfif isdefined("form.Dfamiliar")>1<cfelse>0</cfif>
					from DConceptoDeduc
					where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnterior.EIRid#">
				</cfquery>
			</cfif>
		</cftransaction>
	
	<!--- Cambio de Detalle --->
	<cfelseif Form.frame eq "IR" and Form.Accion eq "ECambio">
		<!--- Actualiza Encabezado --->
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "ImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.IRtimestamp#"
			field1 = "IRcodigo"
			type1 = "char"
			value1 = "#form.IRcodigo#">
		<cfquery name="rs" datasource="sifcontrol">
			update ImpuestoRenta
			set IRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
				IRcodigoPadre=<cfif len(trim(Form.IRcodigoPadre))><cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigoPadre#"><cfelse>null</cfif>,
				IRTipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>
		<!--- Actualiza Detalle --->
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "EImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.EIRtimestamp#"
			field1 = "EIRid"
			type1 = "numeric"
			value1 = "#form.EIRid#">
		<cfquery name="rs" datasource="sifcontrol">
			update EImpuestoRenta
			set EIRdesde=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EIRdesde)#">,
				EIRhasta=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EIRhasta)#">,
				EIRestado=0
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>					
		<cfset emodo = 'CAMBIO'>
	
	<cfelseif Form.frame eq "IR" and Form.Accion eq "EBaja">
		<cfquery name="rs" datasource="sifcontrol">
			delete from DConceptoDeduc
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">				
		</cfquery>				
		<cfquery name="rs" datasource="sifcontrol">	
			delete from DImpuestoRenta
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>
		<cfquery name="rs" datasource="sifcontrol">
			delete from EImpuestoRenta
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>
	<cfelseif Form.frame eq "IR" and Form.Accion eq "EAplicar">
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "EImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.EIRtimestamp#"
			field1 = "EIRid"
			type1 = "numeric"
			value1 = "#form.EIRid#">
		<cfquery name="rs" datasource="sifcontrol">
			update EImpuestoRenta
			set EIRestado=1--Listo
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>
	<cfelseif Form.frame eq "IR" and Form.Accion eq "EModificar">
		<cfset emodo = 'CAMBIO'>
	<cfelseif Form.frame eq "IR" and Form.Accion eq "DAlta">
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "ImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.IRtimestamp#"
			field1 = "IRcodigo"
			type1 = "char"
			value1 = "#form.IRcodigo#">
		<cfquery name="rs" datasource="sifcontrol">
			update ImpuestoRenta
			set IRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
				IRcodigoPadre=<cfif len(trim(Form.IRcodigoPadre))><cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigoPadre#"><cfelse>null</cfif>,
				IRTipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "EImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.EIRtimestamp#"
			field1 = "EIRid"
			type1 = "numeric"
			value1 = "#form.EIRid#">
		<cfquery name="rs" datasource="sifcontrol">
			update EImpuestoRenta
				set EIRdesde=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EIRdesde)#">,
				EIRhasta=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.EIRhasta)#">,
				EIRestado=0
				where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>	
		<cfset Linf = 0.00>
		<cfquery name="rsInf" datasource="sifcontrol">
			select coalesce(max(DIRsup),0.00) as inf
			from DImpuestoRenta
			where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>
		<cfif rsInf.RecordCount gt 0 and rsInf.inf gt 0>
			<cfset Linf = rsInf.inf + 0.01>
		</cfif>
		<cfquery name="rs" datasource="sifcontrol">
			Insert into DImpuestoRenta(EIRid, DIRinf, DIRsup, DIRporcentaje, DIRmontofijo,DIRporcexc, DIRmontoexc)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#Linf#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRsup#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRporcentaje#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRmontofijo#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRporcexc#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRmontoexc#">
				)
		</cfquery>	
		<cfset emodo = 'CAMBIO'>
	<cfelseif Form.frame eq "IR" and Form.Accion eq "DCambio">
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "ImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.IRtimestamp#"
			field1 = "IRcodigo"
			type1 = "char"
			value1 = "#form.IRcodigo#">
		<cfquery name="rs" datasource="sifcontrol">
			update ImpuestoRenta
			set IRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
				IRcodigoPadre=<cfif len(trim(Form.IRcodigoPadre))><cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigoPadre#"><cfelse>null</cfif>,
				IRTipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>	
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "EImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.EIRtimestamp#"
			field1 = "EIRid"
			type1 = "numeric"
			value1 = "#form.EIRid#">
		<cfquery name="rs" datasource="sifcontrol">	
			update EImpuestoRenta
			set EIRdesde=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.EIRdesde,'YYYYMMDD')#">,
			EIRhasta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.EIRhasta,'YYYYMMDD')#">,
			EIRestado=0--Captura
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>	
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "DImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.DIRtimestamp#"
			field1 = "EIRid"
			type1 = "numeric"
			value1 = "#form.EIRid#"
			field2 = "DIRid"
			type2 = "numeric"
			value2 = "#form.DIRid#">
		<cfquery name="rs" datasource="sifcontrol">	
			update DImpuestoRenta
			set DIRsup    = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRsup#">,
			DIRporcentaje = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRporcentaje#">,
			DIRmontofijo  = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRmontofijo#">,
			DIRporcexc    = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRporcexc#">,
			DIRmontoexc   = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DIRmontoexc#">
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
			and DIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DIRid#">
		</cfquery>		
		<cfset emodo = 'CAMBIO'>
		
	<cfelseif Form.frame eq "IR" and Form.Accion eq "DBaja">
		<cfquery name="rs" datasource="sifcontrol">
			delete from DImpuestoRenta
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
			and DIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DIRid#">
		</cfquery>	
		<cfset emodo = 'CAMBIO'>
	<cfelseif Form.frame eq "IR" and Form.Accion eq "DModificar">
		<cfset emodo = 'CAMBIO'>
		<cfset dmodo = 'CAMBIO'>
	<cfelseif Form.frame eq "IR" and Form.Accion eq "DNuevo">
		<cfset emodo = 'CAMBIO'>
	<cfelseif Form.frame eq "CD" and Form.Accion eq "EAlta">
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "ImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.IRtimestamp#"
			field1 = "IRcodigo"
			type1 = "char"
			value1 = "#form.IRcodigo#">
		<cfquery name="rs" datasource="sifcontrol">
			update ImpuestoRenta
			set IRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
				IRcodigoPadre=<cfif len(trim(Form.IRcodigoPadre))><cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigoPadre#"><cfelse>null</cfif>,
				IRTipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>	
		<cfquery name="rs" datasource="sifcontrol">
			insert into ConceptoDeduc
			(IRcodigo, CDcodigo, CDdescripcion)
			values(
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CDcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CDdescripcion#">
				)
		</cfquery>	
	<cfelseif Form.frame eq "CD" and Form.Accion eq "ECambio">
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "ImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.IRtimestamp#"
			field1 = "IRcodigo"
			type1 = "char"
			value1 = "#form.IRcodigo#">
		<cfquery name="rs" datasource="sifcontrol">
			update ImpuestoRenta
			set IRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
				IRcodigoPadre=<cfif len(trim(Form.IRcodigoPadre))><cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigoPadre#"><cfelse>null</cfif>,
				IRTipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>	
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "ConceptoDeduc"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.CDtimestamp#"
			field1 = "CDid"
			type1 = "numeric"
			value1 = "#form.CDid#">
		<cfquery name="rs" datasource="sifcontrol">				
			update ConceptoDeduc
			set CDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CDcodigo#">,
			CDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CDdescripcion#">
			where CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#">
		</cfquery>	
		<cfset emodo = 'CAMBIO'>
	<cfelseif Form.frame eq "CD" and Form.Accion eq "EBaja">
		<cfquery name="rs" datasource="sifcontrol">
			delete from DConceptoDeduc
			where CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#">
		</cfquery>	
		<cfquery name="rs" datasource="sifcontrol">				
			delete from ConceptoDeduc
			where CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#">
		</cfquery>	
	<cfelseif Form.frame eq "CD" and Form.Accion eq "EModificar">
		<cfset emodo = 'CAMBIO'>

	<!--- Alta de Concepto --->
	<cfelseif Form.frame eq "CD" and Form.Accion eq "DAlta">
		<cf_dbtimestamp datasource="sifcontrol"
			table = "ImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.IRtimestamp#"
			field1 = "IRcodigo"
			type1 = "char"
			value1 = "#form.IRcodigo#">
		<cftransaction>
			<cfquery name="rsUpd" datasource="sifcontrol">
				update ImpuestoRenta
				set IRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
					IRcodigoPadre=<cfif len(trim(Form.IRcodigoPadre))><cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigoPadre#"><cfelse>null</cfif>,
					IRTipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">
				where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
			</cfquery>
			
			<cfquery name="rsIns" datasource="sifcontrol">
				insert into ConceptoDeduc 
					(IRcodigo, CDcodigo, CDdescripcion)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CDcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CDdescripcion#"> 
				)
				<cf_dbidentity1 datasource="sifcontrol">
			</cfquery>
			<cf_dbidentity2 datasource="sifcontrol" name="rsIns">
			
			<cfquery name="rsIns2" datasource="sifcontrol">
				insert into DConceptoDeduc
				(CDid, EIRid, DCDvalor, esporcentaje, Dfamiliar)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIns.identity#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCDvalor#">,
					<cfif isdefined("form.esporcentaje")>1<cfelse>0</cfif>
					,<cfif isdefined("form.Dfamiliar")>1<cfelse>0</cfif>
					)
			</cfquery>
			
		</cftransaction>
		<cfset emodo = 'CAMBIO'>
	
	<cfelseif Form.frame eq "CD" and Form.Accion eq "DCambio">
		<cf_dbtimestamp datasource="sifcontrol"
			table = "ImpuestoRenta"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.IRtimestamp#"
			field1 = "IRcodigo"
			type1 = "char"
			value1 = "#form.IRcodigo#">
		<cfquery name="rs" datasource="sifcontrol">
			update ImpuestoRenta
			set IRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.IRdescripcion#">,
				IRcodigoPadre=<cfif len(trim(Form.IRcodigoPadre))><cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigoPadre#"><cfelse>null</cfif>,
				IRTipoPeriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IRTipoPeriodo#">
			where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
		</cfquery>	
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "ConceptoDeduc"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.CDtimestamp#"
			field1 = "CDid"
			type1 = "numeric"
			value1 = "#form.CDid#">
		<cfquery name="rs" datasource="sifcontrol">				
			update ConceptoDeduc
			set CDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CDdescripcion#">
			where CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#">
		</cfquery>	
		<cf_dbtimestamp 
			datasource = "sifcontrol"
			table = "DConceptoDeduc"
			redirect = "ImpuestoRenta.cfm"
			timestamp = "#form.DCDtimestamp#"
			field1 = "CDid"
			type1 = "numeric"
			value1 = "#form.CDid#"
			field2 = "EIRid"
			type2 = "numeric"
			value2 = "#form.EIRid#"
			>
		<cfquery name="rs" datasource="sifcontrol">				
			update DConceptoDeduc
			set DCDvalor=<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DCDvalor#">
				, esporcentaje=<cfif isdefined("form.esporcentaje")>1<cfelse>0</cfif>
				, Dfamiliar = <cfif isdefined("form.Dfamiliar")>1<cfelse>0</cfif> 
			where CDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#">
			and EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>	
		<cfset emodo = 'CAMBIO'>
	<cfelseif Form.frame eq "CD" and Form.Accion eq "DBaja">
		<cfquery name="rs" datasource="sifcontrol">
			delete from DConceptoDeduc
			where CDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#">
			and EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>	
		<cfset emodo = 'CAMBIO'>
	<cfelseif Form.frame eq "CD" and Form.Accion eq "DModificar">
		<cfset emodo = 'CAMBIO'>
		<cfset dmodo = 'CAMBIO'>
	<cfelseif Form.frame eq "CD" and Form.Accion eq "DNuevo">
		<cfset emodo = 'CAMBIO'>
	</cfif>
</cfif>
<!--- Form para devolver parámetros a la pantalla --->
<form action="ImpuestoRenta.cfm" method="post" name="SQLform">
<cfif not isDefined("Form.Nuevo") and modo eq "CAMBIO">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isDefined("modo")>#modo#</cfif>">
		<input name="frame" type="hidden" value="<cfif isDefined("Form.frame")>#Form.frame#</cfif>">
		
		<cfif isDefined("Form.IRcodigo")>
			<input name="IRcodigo" type="hidden" value="#Form.IRcodigo#">
		</cfif>

		<cfif isDefined("Form.EIRid")>
			<input name="EIRid" type="hidden" value="#Form.EIRid#">
		</cfif>

		<cfif IsDefined('form.IRTipoPeriodo')>
			<input name="IRTipoPeriodo" type="hidden" value="#form.IRTipoPeriodo#">
		</cfif>

		<cfif Form.frame eq "IR">
			<cfif not isDefined("Form.ENuevo") and emodo eq "CAMBIO">
				<input name="emodo" type="hidden" value="<cfif isDefined("emodo")>#emodo#</cfif>">
				<cfif not isDefined("Form.DNuevo") and dmodo eq "CAMBIO">
					<input name="dmodo" type="hidden" value="<cfif isDefined("dmodo")>#dmodo#</cfif>">
					<cfif isDefined("Form.DIRid")>
						<input name="DIRid" type="hidden" value="#Form.DIRid#">
					</cfif>
				</cfif>
			</cfif>
		<cfelseif Form.Frame eq "CD">
			<cfif not isDefined("Form.ENuevo") and emodo eq "CAMBIO">
				<input name="emodo" type="hidden" value="<cfif isDefined("emodo")>#emodo#</cfif>">
				
				<cfif not isDefined("Form.DNuevo") and dmodo eq "CAMBIO">
					<input name="dmodo" type="hidden" value="<cfif isDefined("dmodo")>#dmodo#</cfif>">
				</cfif>
			</cfif>
			<cfif isDefined("Form.CDid")>
				<input name="CDid" type="hidden" value="#Form.CDid#">
			</cfif>
		</cfif>
	</cfoutput>
</cfif>
</form>
<html>
<head>
<title>Registro de N&oacute;mina</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<script language="JavaScript" type="text/javascript">document.SQLform.submit();</script>
</body>
</html>
