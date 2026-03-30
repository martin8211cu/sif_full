<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 22-2-2006.
		Motivo: se agrega el campo ECIreversible en alta y cambio.
	Modificado por Gustavo Fonseca H.
		Fecha: 1-3-2006.
		Motivo: Corrige en los insert's para que en el campo BMUsucodigo se grabe el "session.Usucodigo"
		estaba grabando el session.Ecodigo).
	Modificado por Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Cada vez que se da de baja una línea se actualiza el consecutivo de todas las líneas (rsConsecutivo). 
		Esto para mantener la navegación.
		También se modifica para que al agregar un detalle se guarden bien el CFformato, Ccuenta y CFcuenta.	
 --->
<cfset action = "DocContablesImportacion.cfm">
<cfset nuevoDet=false>
<cfparam name="form.CFid" default="">
<cfif isdefined("form.btnBalanceaOfic")>
	<cf_dbfunction name="to_number" args="a.Pvalor" returnvariable="LvarPvalor">
	<cfquery name="rsBalanzaSaldos" datasource="#session.DSN#">
		select 'Balance de Saldos por Oficina' as descripcion,
				 b.Ccuenta as Ccuenta
			from Parametros a, CContables b
			where a.Ecodigo =  #session.Ecodigo# 
			  and a.Pcodigo = 90
			  and a.Ecodigo = b.Ecodigo
			  and #LvarPvalor# = b.Ccuenta
	</cfquery>
	
	<cfif rsBalanzaSaldos.RecordCount EQ 0>
		<cf_errorCode	code = "50240" msg = "No se ha definido Correctamente la Cuenta Contable para Movimiento entre Sucursales en los Parámetros del Sistema. Proceso Cancelado! (Tabla: Parametros)">
	<cfelse>
	
		<cfquery name="rsCFcuentaMin" datasource="#session.DSN#">
			select 
				min(CFcuenta) as MinCFcuenta,
				min(CFformato) as MinCFformato
				from CFinanciera
			where Ecodigo =  #session.Ecodigo# 
			  and Ccuenta =  #rsBalanzaSaldos.Ccuenta# 
		</cfquery>
		
		<cfquery name="rsBalanceOfic" datasource="#session.dsn#">
				select 
					d.Ecodigo, 
					d.ECIid as ECIid ,
					d.Ocodigo as Oficina, 
					d.Mcodigo as Mcodigo,
					d.Dtipocambio as Dtipocambio,
					abs(sum(d.Dlocal * (charindex(d.Dmovimiento, 'C-D') -2))) as Dlocal, 
					abs(sum(d.Doriginal * (charindex(d.Dmovimiento, 'C-D') -2))) as Doriginal,
					case when sum(d.Dlocal * (charindex(d.Dmovimiento, 'C-D') -2)) > 0 then 'C' else 'D' end as Dmovimiento
				from DContablesImportacion d
				where d.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
				group by d.Ecodigo, d.ECIid, d.Ocodigo, d.Mcodigo, d.Dtipocambio
				having abs(sum(d.Dlocal * (charindex(d.Dmovimiento, 'C-D') -2))) <> 0 or abs(sum(d.Doriginal * (charindex(d.Dmovimiento, 'C-D') -2))) <> 0
			</cfquery>
	</cfif> 

	<cfquery name="rsLineaAjusta" datasource="#Session.DSN#">
		select coalesce(max(DCIconsecutivo),1) as linea 
		from DContablesImportacion
		where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
	</cfquery>

	<cfset NewLine = rsLineaAjusta.Linea>

	<cfloop query="rsBalanceOfic">

		<cfset NewLine = NewLine + 1>

		<cfquery name="rsAjustar" datasource="#session.DSN#">
			insert into DContablesImportacion (
					Ecodigo, EcodigoRef, ECIid, DCIconsecutivo, 
					DCIEfecha, Eperiodo, Emes, Ddescripcion, 
					Ddocumento, Dreferencia, Dmovimiento, CFformato, 
					Ccuenta, CFcuenta, 
					Ocodigo, Mcodigo, Doriginal, Dlocal, 
					Dtipocambio, Cconcepto, BMfalta, BMUsucodigo,
					Resultado, CFid, CFcodigo) 
		values (
			 #session.Ecodigo# , 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo_Ccuenta#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#NewLine#">,
			<cfqueryparam cfsqltype="cf_sql_date"    value="#LSParseDateTime(Form.Efecha)#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Eperiodo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Emes#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsBalanzaSaldos.descripcion#">,	
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddocumento#">,
			<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Dreferencia#">,
			<cfqueryparam cfsqltype="cf_sql_char"    value="#rsBalanceOfic.Dmovimiento#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCFcuentaMin.MinCFformato#">,
			 #rsBalanzaSaldos.Ccuenta# ,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFcuentaMin.MinCFcuenta#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBalanceOfic.Oficina#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBalanceOfic.Mcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_double"  value="#rsBalanceOfic.Doriginal#">,
			<cfqueryparam cfsqltype="cf_sql_double"  value="#rsBalanceOfic.Dlocal#">,	
			<cfqueryparam cfsqltype="cf_sql_float"   value="#rsBalanceOfic.Dtipocambio#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			 #Session.Usucodigo# ,
			0,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#isdefined('form.CFid') and len(trim(form.CFid)) eq 0#">,
            <cfqueryparam cfsqltype="cf_sql_char" value="#form.CFcodigo#" null="#isdefined('form.CFcodigo') and len(trim(form.CFcodigo)) eq 0#">
		)
			
		</cfquery>
</cfloop>
</cfif> 

<cfif isdefined("Form.AgregarE")>
	<cftransaction>
		<cfquery name="rsAsiento" datasource="#Session.DSN#">
			insert into EContablesImportacion (Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, Edocbase, Ereferencia, ECIreversible, BMfalta, BMUsucodigo)
			values (
				 #session.Ecodigo# ,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Eperiodo#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Emes#">,
				<cfqueryparam cfsqltype="cf_sql_date"    value="#LSParseDateTime(Form.Efecha)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edocbase#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ereferencia#">,
				<cfif isdefined("form.ChkReversible") and len(trim(form.ChkReversible))>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ChkReversible#">,
				<cfelse>
					0,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				 #Session.Usucodigo# 
			)
			<cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="rsAsiento">
	</cftransaction>
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">
		
<cfelseif isdefined("Form.BorrarE")>
	<cftransaction>
		<cfquery name="rsAsiento" datasource="#Session.DSN#">
			delete from DContablesImportacion
			where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		</cfquery>
		<cfquery name="rsAsiento" datasource="#Session.DSN#">
			delete from EContablesImportacion
			where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		</cfquery>
	</cftransaction>
	<cfset modo = "ALTA">
	<cfset modoDet = "ALTA">
	<cfset action = "DocContablesImportacion-lista.cfm">
		
<cfelseif isdefined("Form.AgregarD")>
	<cfquery name="rsConsecutivo" datasource="#Session.DSN#">
		select coalesce(max(DCIconsecutivo)+1,1) as consecutivo
		from DContablesImportacion
		where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
	</cfquery>
	
	<!--- Construir formato --->
	<cfset Formato = "">
	<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
		<cfset Formato = Form.Cmayor>
	</cfif>
	<cfif isdefined("Form.Cformato") and Len(Trim(Form.Cformato))>
		<cfset Formato = Formato & "-" & Form.Cformato>
	</cfif>

	<cfquery datasource="#Session.DSN#">
		insert into DContablesImportacion (
				Ecodigo, EcodigoRef, ECIid, 
				DCIconsecutivo, DCIEfecha, Eperiodo, Emes, 
				Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, 
				CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo, 
				Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, 
				BMUsucodigo, Resultado, CFid, CFcodigo) 
		values (
			 #session.Ecodigo# , 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo_Ccuenta#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsecutivo.consecutivo#">,
			<cfqueryparam cfsqltype="cf_sql_date"    value="#LSParseDateTime(Form.Efecha)#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Eperiodo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Emes#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddocumento#">,
			<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Dreferencia#">,
			<cfqueryparam cfsqltype="cf_sql_char"    value="#Form.Dmovimiento#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Formato#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_money"   value="#Form.Doriginal#">,
			<cfqueryparam cfsqltype="cf_sql_money"   value="#Form.Dlocal#">,
			<cfqueryparam cfsqltype="cf_sql_float"   value="#Form.Dtipocambio#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			 #Session.Usucodigo# ,
			0,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#isdefined('form.CFid') and len(trim(form.CFid)) eq 0#">,
            <cfqueryparam cfsqltype="cf_sql_char" value="#form.CFcodigo#" null="#isdefined('form.CFcodigo') and len(trim(form.CFcodigo)) eq 0#">
		)
	</cfquery>
	<cfquery name="rsDImportacion" datasource="#Session.DSN#">
		select count(1) as cantidad
		from DContablesImportacion
		where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		and Ecodigo <> EcodigoRef
	</cfquery>
	
	<cfset Intercompany = (rsDImportacion.cantidad GT 0)>
	<cfif Intercompany>
		<cfquery name="rsAsiento" datasource="#Session.DSN#">
			update EContablesImportacion set
				ECIreversible = 0
			where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		</cfquery>
	</cfif>
	
	
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">
		
<cfelseif isdefined("Form.borrarLista") and Form.borrarLista EQ 'S'>
	<cfquery name="rsConsecutivo" datasource="#Session.dsn#">
		select DCIconsecutivo, DCIlinea 
		from DContablesImportacion
		where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		and DCIlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DCIlinea#">
	</cfquery>

	<cfif rsConsecutivo.recordcount NEQ 1>
		<cfquery name="rsConsecutivo" datasource="#Session.dsn#">
			select DCIconsecutivo, DCIlinea
			from DContablesImportacion
			where ECIid        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
			and DCIconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.idConsecutivo#">
		</cfquery>
	</cfif>

	<cfif isdefined("rsConsecutivo") and rsConsecutivo.recordcount EQ 1 and rsConsecutivo.DCIconsecutivo GT 0>
		<cfset LvarDCIconsecutivo = rsConsecutivo.DCIconsecutivo>
		<cfset LvarDCIlinea       = rsConsecutivo.DCIlinea>
		
		<cftransaction action="begin">
			<cfquery datasource="#session.dsn#">
				delete from DContablesImportacion 
				where ECIid          = #Form.ECIid#
				  and DCIlinea       = #LvarDCIlinea#
				  and DCIconsecutivo = #LvarDCIconsecutivo# 
			</cfquery>
	
			<cfquery datasource="#session.dsn#">
				update DContablesImportacion 
				set DCIconsecutivo = DCIconsecutivo - 1
				where ECIid          = #Form.ECIid#
				  and DCIconsecutivo > #LvarDCIconsecutivo# 
			</cfquery>
			<cftransaction action="commit" />
		</cftransaction>
	</cfif>
	
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">

<cfelseif isdefined("Form.CambiarE")>
	
	<cf_dbtimestamp
		datasource="#Session.DSN#"
		table="EContablesImportacion" 
		redirect="DocContablesImportacion.cfm"
		timestamp="#Form.timestampE#"
		field1="ECIid"
		type1="numeric" 
		value1="#Form.ECIid#">
			
	<cftransaction>
		<cfquery name="rsAsiento" datasource="#Session.DSN#">
			update EContablesImportacion set
				Cconcepto 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">,
				Eperiodo 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Eperiodo#">,
				Emes 		 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Emes#">,
				Edescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edescripcion#">,
				Edocbase 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Edocbase#">,
				Ereferencia  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ereferencia#">,
				Efecha 		 = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Efecha)#">,
				ECIreversible= 
				<cfif isdefined("form.ChkReversible") and len(trim(form.ChkReversible))>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ChkReversible#">
				<cfelse>
					0
				</cfif>
			where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		</cfquery>
		
		<cfquery name="rsDImportacion" datasource="#Session.DSN#">
			select count(1) as cantidad
			from DContablesImportacion
			where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
			and Ecodigo <> EcodigoRef
		</cfquery>
		
		<cfset Intercompany = (rsDImportacion.cantidad GT 0)>
		<cfif Intercompany>
			<cfquery name="rsAsiento" datasource="#Session.DSN#">
				update EContablesImportacion set
					ECIreversible = 0
				where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
			</cfquery>
		</cfif>
			
		<cfquery name="rsAsiento" datasource="#Session.DSN#">
			update DContablesImportacion set 
				Cconcepto 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cconcepto#">,
				Eperiodo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Eperiodo#">,
				Emes 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Emes#">,
				Dreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ereferencia#">,
				DCIEfecha 	= <cfqueryparam cfsqltype="cf_sql_date"    value="#LSParseDateTime(Form.Efecha)#">,
				Resultado 	= 0,
                CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#isdefined('form.CFid') and len(trim(form.CFid)) eq 0#">,
                CFcodigo 	= <cfqueryparam cfsqltype="cf_sql_char"    value="#form.CFcodigo#" null="#isdefined('form.CFcodigo') and len(trim(form.CFcodigo)) eq 0#">
			where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECIid#">
		</cfquery>
		
	</cftransaction>

<cfelseif isdefined("Form.CambiarD")>

	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="DContablesImportacion" 
		redirect="DocContablesImportacion.cfm"
		timestamp="#Form.timestampD#"
		field1="DCIlinea,numeric,#Form.DCIlinea#">
		
	<!--- Construir formato --->
	<cfset Formato = "">
	<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
		<cfset Formato = Form.Cmayor>
	</cfif>
	<cfif isdefined("Form.Cformato") and Len(Trim(Form.Cformato))>
		<cfset Formato = Formato & "-" & Form.Cformato>
	</cfif>

	<cfquery name="rsAsiento" datasource="#session.dsn#">
		update DContablesImportacion set 
			EcodigoRef 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ecodigo_Ccuenta#">,
			Ocodigo 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
			Ddescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddescripcion#">,
			Dmovimiento  = <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.Dmovimiento#">,
			Resultado 	 = 0,
			CFformato 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Formato#">,
			CFcuenta 	 = <cfif isdefined("form.CFcuenta") and len(trim(Form.CFcuenta)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#"><cfelse>null</cfif>,
			Ccuenta 	 = <cfif isdefined("form.Ccuenta") and len(trim(Form.Ccuenta)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#"><cfelse>null</cfif>,
			Doriginal    = <cfqueryparam cfsqltype="cf_sql_money"   value="#Form.Doriginal#">,
			Dlocal 		 = <cfqueryparam cfsqltype="cf_sql_money"   value="#Form.Dlocal#">,
			Mcodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
			Dtipocambio  = <cfqueryparam cfsqltype="cf_sql_float"   value="#Form.Dtipocambio#">,
			Ddocumento 	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddocumento#">,
            CFid	     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#isdefined('form.CFid') and len(trim(form.CFid)) eq 0#">,
            CFcodigo	 = <cfqueryparam cfsqltype="cf_sql_char"    value="#form.CFcodigo#" null="#isdefined('form.CFcodigo') and len(trim(form.CFcodigo)) eq 0#">
		where DCIlinea   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DCIlinea#">
	</cfquery>
	<cfset modo="CAMBIO">
	<cfset modoDet="CAMBIO">
	<cfset nuevoDet=false>
	
<cfelseif isdefined("Form.NuevoD")>
	<cfset modoDet="ALTA">
	<cfset nuevoDet=true>
		
<cfelseif isdefined("Form.NuevoE")>
	<cfset action = "DocContablesImportacion.cfm?NuevoE='NuevoE'">
	<cfset modo="ALTA">	
	<cfset nuevoDet=false>
	
<!--- Verificacion de Cuentas Financieras --->
<cfelseif isdefined("Form.btnVerificarCtas")>
	
		<cfinvoke 
		 component="sif.Componentes.CG_AplicaImportacionAsiento"
		 method="CG_VerficaImportacionAsiento"
		 returnvariable="LvarMSG">
			<cfinvokeargument name="ECIid" value="#Form.ECIid#"/>
			<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
			<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
			<cfinvokeargument name="ValidacionInterfaz16" value="false"/>
		</cfinvoke>
	
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">
	
</cfif>
<cfoutput>
	<form action="#action#" method="post" name="sql">
		<input name="modo" 			type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="modoDet" 		type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">	
		<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>#form.PageNum_lista#</cfif>" tabindex="-1">
		<input name="descripcion" 	type="hidden" value="<cfif isdefined("form.descripcion")and len(trim(form.descripcion))>#form.descripcion#</cfif>" tabindex="-1">
		<input name="periodo" 		type="hidden" value="<cfif isdefined("form.periodo")and len(trim(form.periodo))>#form.periodo#</cfif>" tabindex="-1">
		<input name="mes" 			type="hidden" value="<cfif isdefined("form.mes") and len(trim(form.mes))>#form.mes#</cfif>" tabindex="-1">
		<input name="ver" 			type="hidden" value="<cfif isdefined("form.ver") and len(trim(form.ver)) >#form.ver#</cfif>" tabindex="-1">
		<input name="Usucodigo" 	type="hidden" value="<cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>#form.Usucodigo#</cfif>" tabindex="-1">
		<input name="fechadesde" 	type="hidden" value="<cfif isdefined("form.fechadesde") and len(trim(form.fechadesde))>#form.fechadesde#</cfif>" tabindex="-1">
		<input name="fechahasta" 	type="hidden" value="<cfif isdefined("form.fechahasta") and len(trim(form.fechahasta))>#form.fechahasta#</cfif>" tabindex="-1">
	<cfif isdefined("rsAsiento.identity")>
		<input name="ECIid_F" type="hidden" value="<cfif isdefined("rsAsiento.identity")>#rsAsiento.identity#</cfif>">
	<cfelseif not isdefined("Form.NuevoE")>
		<input name="ECIid_F" type="hidden" value="<cfif isdefined("Form.ECIid_F") and not isDefined("Form.BorrarE")>#Form.ECIid_F#</cfif>">		
	<cfelse>
		<input name="ECIid_F" type="hidden" value="">
	</cfif>
	
	<cfif isdefined("Form.DCIlinea") and nuevoDet EQ false and not (isdefined('form.borrarLista') and form.borrarLista EQ 'S')>
		<input name="DCIlinea" type="hidden" value="#Form.DCIlinea#">    	
	</cfif>
	<cfif isdefined("Form.Aplicar")>
		<input name="Aplicar" type="hidden" value="#Form.Aplicar#">
		<input name="Cconcepto" type="hidden" value="<cfif isdefined("Form.Cconcepto")>#Form.Cconcepto#</cfif>">
		<input name="Eperiodo" type="hidden" value="<cfif isdefined("Form.Eperiodo")>#Form.Eperiodo#</cfif>">
		<input name="Emes" type="hidden" value="<cfif isdefined("Form.Emes")>#Form.Emes#</cfif>">
	</cfif>
	<cfif isdefined("Form.btnImportar")>
		<input name="btnImportar" type="hidden" value="#Form.btnImportar#">
	</cfif>
	<cfif isdefined("form.LvarDCIconsecutivo") and len(trim(form.LvarDCIconsecutivo))>
		<input name="LvarDCIconsecutivo" value="#form.LvarDCIconsecutivo#" type="hidden">
	</cfif>
	<!---Mantener los Filtros del listado del detalle--->
	<cfif isdefined("Form.fDescripcion") and nuevoDet EQ false and not (isdefined('form.borrarLista') and form.borrarLista EQ 'S')>
		<input name="fDescripcion" type="hidden" value="#Form.fDescripcion#">    	
	</cfif>
	<cfif isdefined("Form.fCformato") and nuevoDet EQ false and not (isdefined('form.borrarLista') and form.borrarLista EQ 'S')>
		<input name="fCformato" type="hidden" value="#Form.fCformato#">    	
	</cfif>
	<cfif isdefined("Form.fOcodigo") and nuevoDet EQ false and not (isdefined('form.borrarLista') and form.borrarLista EQ 'S')>
		<input name="fOcodigo" type="hidden" value="#Form.fOcodigo#">    	
	</cfif>
	<cfif isdefined("Form.flinea") and nuevoDet EQ false and not (isdefined('form.borrarLista') and form.borrarLista EQ 'S')>
		<input name="flinea" type="hidden" value="#Form.flinea#">    	
	</cfif>
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

