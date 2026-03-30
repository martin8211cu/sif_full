<cfsetting requesttimeout="3600">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<!--- ************************************ --->
<!--- *** ALTA DEL ENCABEZADO         **** --->
<!--- ************************************ --->
<cfif isdefined("form.ALTA")>
	<cftransaction>
		<cfquery name="RSInsert" datasource="#session.DSN#">
			insert into AFMovsEmpresasE (
				Ecodigo, 
				AFMovsEstado, 
				AFMovsDescripcion, 
				AFMovsExplicacion,
				AFMovsFecha,
				BMUsucodigo)
				values (
				 #session.Ecodigo# ,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFMovsDescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFMovsExplicacion#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.AFMovsFecha#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
				<cf_dbidentity1 datasource="#session.DSN#">
		 </cfquery>
		 <cf_dbidentity2 datasource="#session.DSN#" name="RSInsert">
	 </cftransaction>
	 <cfset form.AFMovsID = RSInsert.identity >
	 <cfset params = "?AFMovsID=#form.AFMovsID#">
	 <cflocation url="AF_Traslados.cfm#params#">
<!--- ************************************ --->
<!--- *** CAMBIO DEL ENCABEZADO       **** --->
<!--- ************************************ --->
<cfelseif isdefined("form.MODIFICAR")>
	<cfquery name="RSUpdate" datasource="#session.DSN#">
		update AFMovsEmpresasE 
		set 	AFMovsDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFMovsDescripcion#">,
				AFMovsExplicacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFMovsExplicacion#">,
				AFMovsFecha = 		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.AFMovsFecha#">
		where 	Ecodigo = 			 #session.Ecodigo# 
		and		AFMovsID= 			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">		
	</cfquery>	
	<cfset params = "?AFMovsID=#form.AFMovsID#">
	<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>
		<cfset params = "?AFMovsID=#form.AFMovsID#&AFMovsIDlinea=#form.AFMovsIDlinea#">
	</cfif>
	<cflocation url="AF_Traslados.cfm#params#">
<!--- ************************************ --->
<!--- *** BAJA DEL ENCABEZADO         **** --->
<!--- ************************************ --->
<cfelseif isdefined("form.ELIMINARDOC")>	
	<cftransaction>
		<cfquery name="RSUpdate" datasource="#session.DSN#">
			Delete from AFMovsEmpresasD 
			where 	Ecodigo = 			 #session.Ecodigo# 
			and		AFMovsID= 			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">		
		</cfquery>
		<cfquery name="RSUpdate" datasource="#session.DSN#">
			Delete from AFMovsEmpresasE 
			where 	Ecodigo = 			 #session.Ecodigo# 
			and		AFMovsID= 			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">		
		</cfquery>	
	</cftransaction>
	<cflocation url="AF_ListaTraslados.cfm">
<!--- ************************************ --->
<!--- *** AGREGAR LINEAS              **** --->
<!--- ************************************ --->	
<cfelseif isdefined("form.AGREGARLINEAS")>
	<cfsetting requesttimeout="36000">
	<!--- Periodo--->
	<cfquery name="rsPeriodo" datasource="#session.DSN#">
		select p1.Pvalor as value from Parametros p1 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECODIGOORIGEN#"> 
		and Pcodigo = 50
	</cfquery>
	<!--- Mes --->
	<cfquery name="rsMes" datasource="#session.DSN#">
		select p1.Pvalor as value from Parametros p1 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECODIGOORIGEN#"> 
		and Pcodigo = 60
	</cfquery>
	
	<cfquery  name="RS" datasource="#session.DSN#">
		insert into AFMovsEmpresasD 
		(	AFMovsID,
			Ecodigo,
			Ecodigo_O,
			Aid,
			Aplaca,
			AFRmotivo,
			ACcodigo,
			ACid,
			CFid,
			AFMovsDValorAdq,
			AFMovsDSaldoAdq,
			AFMovsDValorRev,
			AFMovsDSaldoRev,
			AFMovsDValorMej,
			AFMovsDSaldoMej,
			AFMovsDVidaUtil,
			AFMovsVUusado)
		
		select 
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AFMovsID#"> as AFMovsID,
			 #session.Ecodigo#  as Ecodigo,
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ECODIGOORIGEN#"> as Ecodigo_O,
			a.Aid,
			a.Aplaca,
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.AFRmotivoORI#"> as AFRmotivo,
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ACcodigoDES#">  as ACcodigo,
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ACidDES#"> as ACid,
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.CFidDES#"> as CFid,
			<!--- ********************************************************************** --->
			<!--- *** Verficar que se este cargando correctamente estos campos      **** --->
			<!--- *** AFMovsDValorAdq,                                              **** --->
			<!--- *** AFMovsDSaldoAdq,                                              **** --->
			<!--- *** AFMovsDValorRev,                                              **** --->
			<!--- *** AFMovsDSaldoRev,                                              **** --->
			<!--- *** AFMovsDValorMej,                                              **** --->
			<!--- *** AFMovsDSaldoMej,                                              **** --->
			<!--- *** AFMovsDVidaUtil,                                              **** --->
			<!--- *** AFMovsVUusado                                                 **** --->
			<!--- ********************************************************************** --->

			
			
			af.AFSvaladq as AFMovsDValorAdq, 
			(af.AFSvaladq - af.AFSdepacumadq) as AFMovsDSaldoAdq,
			af.AFSvalrev as AFMovsDValorRev, 
			(af.AFSvalrev - af.AFSdepacumrev) as AFMovsDSaldoRev, 
			af.AFSvalmej as AFMovsDValorMej, 
			(af.AFSvalmej - af.AFSdepacummej) as AFMovsDSaldoMej, 
			af.AFSvutiladq as AFMovsDVidaUtil, 
			(af.AFSvutiladq - af.AFSsaldovutiladq) as AFMovsVUusado

		from Activos a
		inner join 	AFSaldos af	
			on af.Aid = a.Aid
			and af.Ecodigo = a.Ecodigo	
			and af.AFSperiodo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.value#">
			and af.AFSmes 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.value#">
			and af.Aid = a.Aid
			<cfif isdefined("form.CFIDORI") and len(trim(form.CFIDORI))>
				and af.CFid = #form.CFIDORI#
			</cfif>
			<cfif isdefined("form.OcodigoORI") and len(trim(form.OcodigoORI))>
				and af.Ocodigo = #form.OcodigoORI#
			</cfif>
			<cfif isdefined("form.AFCcodigoORI") and len(trim(form.AFCcodigoORI))>
				and af.AFCcodigo = #form.AFCcodigoORI#
			</cfif>
		inner join 	CFuncional cf
			on af.CFid = cf.CFid
			and af.Ecodigo  = cf.Ecodigo
			<cfif isdefined("form.DcodigoORI") and len(trim(form.DcodigoORI))>
				and cf.Dcodigo = #form.DcodigoORI#
			</cfif>			 

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECODIGOORIGEN#">
		and a.Astatus = 0
		
		<cfif isdefined("form.AplacaO") and len(trim(form.AplacaO))>
			and lower(a.Aplaca) = '#Lcase(trim(form.AplacaO))#'
		</cfif>
		
		<cfif isdefined("form.ACcodigoORI") and len(trim(form.ACcodigoORI))>
			and a.ACcodigo = #form.ACcodigoORI#
		</cfif>
		
		<cfif isdefined("form.ACidORI") and len(trim(form.ACidORI))>
			and a.ACid = #form.ACidORI#
		</cfif>
		<!--- valida que la placa no vuelva agregarse --->
		and not exists (
			select x.Aid
			from AFMovsEmpresasD x
			where <!--- x.Ecodigo_O = a.Ecodigo  CCC. Sobra validar el Ecodigo. Aid es clustred unique
			and ---> x.Aid = a.Aid
			<!--- CCC. Dado que el Aid es un identity no se requiere validar las empresas
			and x.Ecodigo =  #session.Ecodigo# 
			and x.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECODIGOORIGEN#">
			--->
			and x.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		) 
		<!--- valida que la placa no este agregada en otra relación  --->
		and not exists (
			select x.Aid
			from AFMovsEmpresasD x
			inner join AFMovsEmpresasE y
				on  x.Ecodigo = y.Ecodigo
				and x.AFMovsID = y.AFMovsID
				and y.AFMovsEstado = 0
			where <!--- x.Ecodigo_O = a.Ecodigo CCC.Sobra validar el Ecodigo. Aid es clustred unique
			and ---> x.Aid = a.Aid
			<!--- CCC. Dado que el Aid es un identity no se requiere validar las empresas, ademas que afecta el objetivo de la validacion
			and x.Ecodigo =  #session.Ecodigo# 
			and x.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ECODIGOORIGEN#">
			--->
			and x.AFMovsID != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		)
	</cfquery>
	<cfset params = "?AFMovsID=#form.AFMovsID#">
	<cflocation url="AF_Traslados.cfm#params#">
<!--- ************************************ --->
<!--- *** NUEVAS LINEAS               **** --->
<!--- ************************************ --->		
<cfelseif isdefined("form.Nueva")>	
	<cfset params = "?AFMovsID=#form.AFMovsID#">
	<cflocation url="AF_Traslados.cfm#params#">
<!--- ************************************ --->
<!--- *** MODIFICAR  LINEAS           **** --->
<!--- ************************************ --->		
<cfelseif isdefined("form.ModifLineas")>
	<cfquery  name="ModifLinea" datasource="#session.DSN#">
		update AFMovsEmpresasD
			set 
			AFRmotivo   =   <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFRmotivoORI#">,
			ACcodigo    =   <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoDES#">,
			ACid        =   <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACidDES#">,
			CFid   		=	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CFidDES#">
		where AFMovsID  =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		and AFMovsIDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsIDlinea#">
		and Ecodigo =  #session.Ecodigo# 	   
	</cfquery>
	<cfset params = "?AFMovsID=#form.AFMovsID#&AFMovsIDlinea=#form.AFMovsIDlinea#">		
	<cflocation url="AF_Traslados.cfm#params#">
<!--- ************************************ --->
<!--- *** BORRAR  LINEAS              **** --->
<!--- ************************************ --->		
<cfelseif isdefined("form.DELLINEA") and form.DELLINEA eq 'LINEA'>	
	<cfquery  name="delLinea" datasource="#session.DSN#">
		delete from AFMovsEmpresasD
		where AFMovsID  =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		and AFMovsIDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsIDlinea#">
		and Ecodigo =  #session.Ecodigo# 	   
	</cfquery>
	<cfset params = "?AFMovsID=#form.AFMovsID#">		
	<cflocation url="AF_Traslados.cfm#params#">
<!--- ************************************ --->
<!--- *** APLICAR                     **** --->
<!--- ************************************ --->		
<cfelseif isdefined("form.Aplicar")>
	<cf_dbtemp name="Errores" returnvariable="Errores" datasource="#session.dsn#">
		<cf_dbtempcol name="orden"   type="smallint" mandatory="no">
		<cf_dbtempcol name="Empresa" type="char(250)" mandatory="no">
		<cf_dbtempcol name="Placa"   type="char(250)" mandatory="no">
		<cf_dbtempcol name="Error"   type="char(250)" mandatory="no">
	</cf_dbtemp>
	<!--- *** inicial validacion          **** --->
	
	<!--- *** valida periodos y mes            **** --->
	
	<!--- Periodo--->
	<cfquery name="rsPeriodo" datasource="#session.DSN#">
		select p1.Pvalor as value from Parametros p1 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and Pcodigo = 50
	</cfquery>
	
	<cfset Vper = rsPeriodo.value>
	
	<!--- Mes --->
	<cfquery name="rsMes" datasource="#session.DSN#">
		select p1.Pvalor as value from Parametros p1 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and Pcodigo = 60
	</cfquery>
	
	<cfset Vmes = rsMes.value>
	
	<cfquery  name="RsEmpresas" datasource="#session.DSN#">
		select distinct e.Enombre,Ecodigo_O, p.Pvalor as periodo, m.Pvalor  as mes 
		from AFMovsEmpresasD a
			inner join Parametros p 
				on a.Ecodigo_O = p.Ecodigo
				and p.Pcodigo = 50	
			inner join Parametros m 
				on a.Ecodigo_O = m.Ecodigo
				and m.Pcodigo = 60		
			inner join Empresa e
				on 	a.Ecodigo_O = e.Ereferencia
				and CEcodigo = #session.CEcodigo#	
		where AFMovsID  =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		and a.Ecodigo =  #session.Ecodigo# 	   
	</cfquery>	
	
	<!--- *** valida que todas las empresas se encuentren dentro del mismo Periodo-Mes **** --->
	<cfloop query="RsEmpresas">
		<cfif RsEmpresas.periodo neq rsPeriodo.value or RsEmpresas.mes neq rsMes.value>
			 <cfquery  name="INS_Error" datasource="#session.DSN#">
				insert into #Errores# values (1,<cfqueryparam cfsqltype="cf_sql_varchar" value="#RsEmpresas.Enombre#">,null,'Los activos de esta empresa se encuentran en un periodo y/o mes (#RsEmpresas.periodo#-#RsEmpresas.mes#)  distinto al de la empresa destino. (#rsPeriodo.value#-#rsMes.value#)')
			 </cfquery>
		</cfif>
	</cfloop>

	<!--- *** valida que la placa no exista en la empresa destino **** --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #Errores# (orden,Empresa,Placa,Error)
		select 2,e.Enombre,a.Aplaca,'Ya existe un activo en la empresa destino con el mismo número de placa'
		from AFMovsEmpresasD a
		inner join Empresa e
			on 	a.Ecodigo_O = e.Ereferencia
			and CEcodigo = #session.CEcodigo#
		where exists (Select 1
					   from Activos ac 
					   where ac.Ecodigo =  #session.Ecodigo# 
					     and ltrim(rtrim(ac.Aplaca)) = ltrim(rtrim(a.Aplaca)) )
		  and AFMovsID  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		  and a.Ecodigo =  #session.Ecodigo# 		
	</cfquery>


	<!--- *** valida que el saldo del activo (Totalmente Depreciado) no sea cero **** --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #Errores# (orden,Empresa,Placa,Error)
		select 3,e.Enombre,a.Aplaca,'El saldo del activo es cero '
		from AFMovsEmpresasD a
		inner join Empresa e
			on 	a.Ecodigo_O = e.Ereferencia
			and CEcodigo = #session.CEcodigo#
		inner join Activos b
			on 	a.Ecodigo_O = b.Ecodigo	
			and a.Aid = b.Aid	
  		    and (a.AFMovsDSaldoAdq + a.AFMovsDSaldoRev + a.AFMovsDSaldoMej) <=  b.Avalrescate
		    and AFMovsID  =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		    and a.Ecodigo =  #session.Ecodigo# 	   		
	</cfquery>
	 
	<!--- *** valida que los saldos de la tabla detalle coinciden con los del periodo-mes **** ---> 
	<cfquery name="INS_Error" datasource="#session.DSN#">
		select count(1) as actsaldos
		from AFMovsEmpresasD a
		inner join Empresa e
			on 	a.Ecodigo_O = e.Ereferencia
			and CEcodigo = #session.CEcodigo#

		inner join Activos b
			on  a.Ecodigo_O = b.Ecodigo	
			and a.Aid 		= b.Aid	

		inner join AFSaldos c
			on 	a.Ecodigo_O = c.Ecodigo	
			and a.Aid = c.Aid	
  		    and ( a.AFMovsDSaldoAdq != (c.AFSvaladq - c.AFSdepacumadq) 
			or a.AFMovsDSaldoMej != (c.AFSvalmej - c.AFSdepacummej)
			or a.AFMovsDSaldoRev != (c.AFSvalrev - c.AFSdepacumrev) )
			and c.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Vper#">
			and c.AFSmes 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Vmes#">
		    and AFMovsID  	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		    and a.Ecodigo 	 =  #session.Ecodigo# 	
	</cfquery>
	
	<cfif INS_Error.actsaldos gt 0>
	
		<cfquery name="INS_Error" datasource="#session.DSN#">
		UPDATE AFMovsEmpresasD
		set AFMovsDValorAdq = c.AFSvaladq, 
			AFMovsDSaldoAdq = (c.AFSvaladq - c.AFSdepacumadq),
			AFMovsDValorRev = c.AFSvalrev, 
			AFMovsDSaldoRev = (c.AFSvalrev - c.AFSdepacumrev),
			AFMovsDValorMej = c.AFSvalmej,
			AFMovsDSaldoMej = (c.AFSvalmej - c.AFSdepacummej),
			AFMovsDVidaUtil = c.AFSvutiladq, 
			AFMovsVUusado   = (c.AFSvutiladq - c.AFSsaldovutiladq)
			
		from Empresa e, Activos b, AFSaldos c
		where AFMovsEmpresasD.Ecodigo_O = e.Ereferencia
		  and e.CEcodigo = #session.CEcodigo#
		  and AFMovsEmpresasD.Ecodigo_O = b.Ecodigo	
 		  and AFMovsEmpresasD.Aid 	  = b.Aid	
		  and AFMovsEmpresasD.Ecodigo_O = c.Ecodigo	
		  and AFMovsEmpresasD.Aid = c.Aid	
		  and AFMovsEmpresasD.AFMovsDSaldoAdq = (c.AFSvaladq - c.AFSdepacumadq) 
		  and AFMovsEmpresasD.AFMovsDSaldoMej = (c.AFSvalmej - c.AFSdepacummej)
		  and AFMovsEmpresasD.AFMovsDSaldoRev = (c.AFSvalrev - c.AFSdepacumrev)
		  and c.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Vper#">
		  and c.AFSmes 	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Vmes#">
		  and AFMovsID     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		  and AFMovsEmpresasD.Ecodigo =  #session.Ecodigo# 	
		</cfquery>
	
	</cfif>	
	
	<!--- Valida que todos los activos a retirar tengan vales vigentes --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #Errores# (orden,Empresa,Placa,Error)
		select 4,e.Enombre,b.Aplaca,'El Activo no tiene un vale vigente'
		from AFMovsEmpresasD a
				inner join Empresa e
					on a.Ecodigo_O = e.Ereferencia
				   and CEcodigo = #session.CEcodigo#
				   
				inner join Activos b
					on a.Aid = b.Aid
				   and a.Ecodigo_O = b.Ecodigo

		where a.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
		  and not exists (Select 1
						  from AFResponsables c
						   where c.Aid = b.Aid
							 and c.Ecodigo = b.Ecodigo
							 and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between c.AFRfini and c.AFRffin)
	</cfquery>
	
	<cfquery name="INS_Error" datasource="#session.DSN#">
		select Empresa,Placa,Error 
		from #Errores#
		order by Empresa,orden,Placa 
	</cfquery>
	
	<cfif INS_Error.recordCount GT 0>
		<cf_web_portlet_start border="true" titulo="Lista de errores" skin="#Session.Preferences.Skin#">
		<form action="AF_Traslados.cfm"  method="post" name="form1" id="form1">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="center" colspan="3"><strong>Se presentaron los siguentes errores a la hora de trasladar los activos</strong></td>
			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr bgcolor="#CCCCCC">
				<td><strong>Empresa</strong></td>
				<td><strong>Placa</strong></td>
				<td><strong>Error</strong></td>
			</tr>		
		<cfloop query="INS_Error">
			<cfoutput>
			<tr>
				<td>#INS_Error.Empresa#</td>
				<td>#INS_Error.Placa#</td>
				<td>#INS_Error.Error#</td>
			</tr>
			</cfoutput>
		</cfloop>
			<tr bgcolor="#CCCCCC">
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3"><cf_botones values="Regresar" names="Regresar" tabindex="4"></td>
			</tr>
		</table>
		<cfoutput>
			<input name="AFMovsID" type="hidden" value="#form.AFMovsID#">
			<input name="AFMovsIDlinea" type="hidden" value="<cfif isdefined("form.AFMovsIDlinea") and len(trim(form.AFMovsIDlinea))>#form.AFMovsIDlinea#</cfif>">
		</cfoutput>
		</form>
		<cf_web_portlet_end>
	<cfelse>
		<!--- ************************************ --->
		<!--- *** Todas las validaciones son  **** --->
		<!--- *** correctas inicia traslado   **** --->
		<!--- ************************************ --->	
		<cfquery name="rsMoneda" datasource="#session.DSN#">
			select Mcodigo
			from Empresas 
			where Ecodigo =  #session.Ecodigo# 
		</cfquery>		
		
		<cfquery name="RS_Motivo" datasource="#session.DSN#">
			select 	AFMovsDescripcion,AFMovsExplicacion 				
			from AFMovsEmpresasE a
			where a.AFMovsID  =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
			and a.Ecodigo =  #session.Ecodigo# 	  
		</cfquery>		
		
		
		<cfquery name="RS_Empresas" datasource="#session.DSN#">
			select distinct a.Ecodigo_O, e.Edescripcion, enc.AFMovsDescripcion as AFRmotivo, a.AFRmotivo as CodAFRmotivo
			from AFMovsEmpresasD a
					inner join Empresas e
						on e.Ecodigo = a.Ecodigo_O
					
					inner join AFMovsEmpresasE enc
						on enc.AFMovsID = a.AFMovsID
						
			where a.AFMovsID  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
			and a.Ecodigo =  #session.Ecodigo# 
			order by  a.Ecodigo_O
		</cfquery>
		
		<cftransaction>
		
			<cfloop query="RS_Empresas">
			
				<cfset Lvar_empresa = RS_Empresas.Ecodigo_O>
				<cfset motivo = RS_Empresas.CodAFRmotivo>
				<cfset nombreEmp = RS_Empresas.Edescripcion>
				
				<!--- *** inserta encabezado en AGTProceso  **** --->	
				<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaRelacion"
				returnvariable="rsResultadosRA">
					<cfinvokeargument name="Ecodigo" value="#Lvar_empresa#">
					<cfinvokeargument name="Conexion" value="#session.dsn#">
					<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
					<cfinvokeargument name="IPregistro" value="#session.sitio.ip#">
					<cfinvokeargument name="AGTPdescripcion" value="#RS_Motivo.AFMovsDescripcion# Empresa #Lvar_empresa#">
					<cfinvokeargument name="AFRmotivo" value="#motivo#">
					<cfinvokeargument name="TransaccionActiva" value="true">
					<cfinvokeargument name="AGTPrazon" value="#RS_Motivo.AFMovsExplicacion#">
				</cfinvoke>
				
				<cfset llave = rsResultadosRA>
				<cfquery name="RS_lineas" datasource="#session.DSN#">
					select Aid
					from AFMovsEmpresasD a
					where a.AFMovsID  =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
					and a.Ecodigo   =  #session.Ecodigo# 	  
					and a.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_empresa#">	
					order by  a.Ecodigo_O
				</cfquery>
					
				<cfloop query="RS_lineas">
					
					<!--- *** inserta lineas  en ADTProceso  **** --->	
					<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaActivo"
						returnvariable="rsResultadosDET">
					<cfinvokeargument name="Ecodigo" value="#Lvar_empresa#">
					<cfinvokeargument name="Conexion" value="#session.dsn#">
					<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
					<cfinvokeargument name="IPregistro" value="#session.sitio.ip#">
					<cfinvokeargument name="AGTPid" value="#llave#">
					<cfinvokeargument name="ADTPrazon" value="#RS_Motivo.AFMovsExplicacion#">
					<cfinvokeargument name="Aid" value="#RS_lineas.Aid#">
					<cfinvokeargument name="TransaccionActiva" value="true">
					</cfinvoke>

				</cfloop>
				
				<!--- Adquiere los activos en la empresa destino --->			
								
				<!--- Valida que el Empleado exista en la empresa destino --->
				<cfquery datasource="#session.dsn#" name="rsVerificaEmpleados">
					Select count(1) as error
					from AFMovsEmpresasD a		
						inner join Activos b
							on a.Aid = b.Aid
						   and a.Ecodigo_O = b.Ecodigo
						
						inner join AFResponsables c
							on c.Aid = b.Aid
						   and c.Ecodigo = b.Ecodigo
						   
						inner join DatosEmpleado demp
							on c.DEid = demp.DEid
						   and c.Ecodigo = demp.Ecodigo						   
						   <!---and not exists (Select 1
										   from DatosEmpleado de
										   where de.DEidentificacion = demp.DEidentificacion
										     and de.Ecodigo =  #session.Ecodigo# )
					   --->
					where a.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
					  and a.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_empresa#">
					  and not exists (Select 1
										   from DatosEmpleado de
										   where de.DEidentificacion = demp.DEidentificacion
										     and de.Ecodigo =  #session.Ecodigo# )
					   
				</cfquery>
				
				<cfif rsVerificaEmpleados.error gt 0>
					<cf_errorCode	code = "50099" msg = "Existen Vales asociados a Activos de la empresa Origen que contienen empleados que no existen en la empresa destino">
				</cfif>
				
				<!--- Valida que la categoria-clase exista en la empresa destino --->
				<cfquery datasource="#session.dsn#" name="rsVerificaCat">
					Select count(1) as error
					from AFMovsEmpresasD a		
						inner join Activos b
							on a.Aid = b.Aid
						   and a.Ecodigo_O = b.Ecodigo 

						inner join ACategoria acat
							on b.ACcodigo = acat.ACcodigo
						   and b.Ecodigo  = acat.Ecodigo

						inner join AClasificacion acla
							on b.ACid     = acla.ACid
						   and b.ACcodigo = acla.ACcodigo
						   and b.Ecodigo  = acla.Ecodigo
						   												
						   <!---and not exists (Select 1
										   from AClasificacion cla
										   			inner join ACategoria catb
														on cla.ACcodigo = catb.ACcodigo
													   and cla.Ecodigo = catb.Ecodigo
													   and catb.ACcodigodesc = acat.ACcodigodesc
													   
										   where cla.ACcodigodesc = acla.ACcodigodesc
										     and cla.Ecodigo =  #session.Ecodigo# )--->
					   
					where a.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
					  and a.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_empresa#">
					  and not exists (Select 1
										   from AClasificacion cla
										   			inner join ACategoria catb
														on cla.ACcodigo = catb.ACcodigo
													   and cla.Ecodigo = catb.Ecodigo
													   and catb.ACcodigodesc = acat.ACcodigodesc
													   
										   where cla.ACcodigodesc = acla.ACcodigodesc
										     and cla.Ecodigo =  #session.Ecodigo# )
				</cfquery>
				
				<cfif rsVerificaCat.error gt 0>
					<cf_errorCode	code = "50100" msg = "Existen Activos de la empresa Origen que estan asociados a una categoria-clase que no existe en la empresa destino">
				</cfif>				
												
				<!--- Valida que el centro funcional exista en la empresa destino --->
				<cfquery datasource="#session.dsn#" name="rsVerificaCF">
					Select count(1) as error
					from AFMovsEmpresasD a		
						inner join Activos b
							on a.Aid = b.Aid
						   and a.Ecodigo_O = b.Ecodigo 

						inner join CFuncional cfc
							on a.CFid = cfc.CFid
						   and b.Ecodigo  = cfc.Ecodigo						
<!---						   and not exists (Select 1
										   from CFuncional cf
										   where cf.CFcodigo = cfc.CFcodigo
										     and cf.Ecodigo =  #session.Ecodigo# )
--->					   
					where a.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
					  and a.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_empresa#">
					  and not exists (Select 1
										   from CFuncional cf
										   where cf.CFcodigo = cfc.CFcodigo
										   and cf.Ecodigo =  #session.Ecodigo# )

				</cfquery>
				
				<cfif rsVerificaCF.error gt 0>
					<cf_errorCode	code = "50101" msg = "Existen Activos de la empresa Origen que estan asociados a un Centro Funcional que no existe en la empresa destino">
				</cfif>
							
				
				<cfquery datasource="#session.dsn#">
					insert into EAadquisicion 
						(Ecodigo, 	EAcpidtrans, 	EAcpdoc, 		EAcplinea, 
						Ocodigo, 	Aid, 			EAPeriodo, 		EAmes, 
						EAFecha, 	Mcodigo, 		EAtipocambio, 	Ccuenta, 
						SNcodigo, 	EAdescripcion, 	EAcantidad, 	EAtotalori, 
						EAtotalloc, EAstatus, 		EAselect, 		Usucodigo, 
						BMUsucodigo)
					
					Select 
							#Session.Ecodigo# as Ecodigo, 
						   'TA' as EAcpidtrans,
						   {fn concat(<cf_dbfunction name="to_char" datasource="#session.dsn#" args="b.Ocodigo">, '-#Vper##RepeatString('0',2-len(Vmes))#-#form.AFMovsID#-#Lvar_empresa#')} as EAcpdoc,
						   1 as EAcplinea,
						   b.Ocodigo,
						   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						   #Vper# as EAPeriodo,
						   #Vmes# as EAmes,
						   <cf_dbfunction name="now">,
						   #rsMoneda.Mcodigo# as Mcodigo,
						   1 as EAtipocambio,
						
						   (Select min(ACcadq)
							from AClasificacion cl
							where cl.Ecodigo  =  #session.Ecodigo# ) as Ccuenta,
						   
						   <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null"> as SNcodigo,
							<cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="Activos Fijos Adquiridos por Traslado desde la empresa: #_Cat# #nombreEmp#"> as EAdescripcion,
						   1 as EAcantidad,						   
						   
						   0 as EAtotalori,
						   0 as EAtotalloc,
						   
						   1 as EAstatus, 		
						   0 as EAselect, 		
						   #session.usucodigo# as Usucodigo, 
						   #session.usucodigo# as BMUsucodigo						   
						   
					from AFMovsEmpresasD a
							inner join CFuncional b
								on a.CFid = b.CFid
							   and a.Ecodigo = b.Ecodigo
					where a.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
					  and a.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_empresa#">						
				    group by b.Ocodigo
				</cfquery>
				
			
				<cfquery datasource="#session.dsn#">
					insert into DAadquisicion 
						(Ecodigo, 	EAcpidtrans, 	EAcpdoc, 	EAcplinea, 
						DAlinea, 	DAtc, 			DAmonto, 	Usucodigo, 	
						BMUsucodigo)
						
					Select #Session.Ecodigo# as Ecodigo,
						   'TA' as EAcpidtrans,
						   {fn concat(<cf_dbfunction name="to_char" datasource="#session.dsn#" args="b.Ocodigo">, '-#Vper##RepeatString('0',2-len(Vmes))#-#form.AFMovsID#-#Lvar_empresa#')} as EAcpdoc,
						 
						   1 as EAcplinea,
						   a.AFMovsIDlinea as DAlinea,
						   1.00 as DAtc,
						   (AFMovsDSaldoAdq + AFMovsDSaldoRev + AFMovsDSaldoMej) as DAmonto,
						   #session.usucodigo# as Usucodigo,
						   #session.usucodigo# as BMUsucodigo
					from AFMovsEmpresasD a
							inner join CFuncional b
								on a.CFid = b.CFid
							   and a.Ecodigo = b.Ecodigo					
					where a.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
					  and a.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_empresa#">													
				</cfquery>

				<cfquery datasource="#session.dsn#">
					insert into DSActivosAdq 
						(Ecodigo, 		EAcpidtrans, 	EAcpdoc, 	EAcplinea, 
						DAlinea, 		AFMid, 			AFMMid, 	CFid, 
						DEid, 			Alm_Aid, 		Aid, 		Mcodigo, 
						AFCcodigo, 		DSAtc, 			SNcodigo, 	ACcodigo, 
						ACid, 			DSdescripcion, 	DSserie, 	DSplaca, 
						DSfechainidep, 	DSfechainirev, 	DSmonto, 	Status, CRDRid, 
						Usucodigo, 		BMUsucodigo)
						
					Select 
							#Session.Ecodigo# as Ecodigo,
						   'TA' as EAcpidtrans,
						   {fn concat(<cf_dbfunction name="to_char" datasource="#session.dsn#" args="d.Ocodigo">, '-#Vper##RepeatString('0',2-len(Vmes))#-#form.AFMovsID#-#Lvar_empresa#')} as EAcpdoc,
						   1 as EAcplinea,
						   a.AFMovsIDlinea as DAlinea,
						   b.AFMid,
						   b.AFMMid,
						   a.CFid,
						   c.DEid,
						   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> ,
						   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> ,
						   #rsMoneda.Mcodigo#,
						   b.AFCcodigo,
						   1.00,
						   <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null"> ,
						   a.ACcodigo,
						   a.ACid,
						   b.Adescripcion,
						   b.Aserie,
						   b.Aplaca,
						   b.Afechainidep,
						   b.Afechainirev,
						   (a.AFMovsDSaldoAdq + a.AFMovsDSaldoRev + a.AFMovsDSaldoMej),
						   1,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> ,	
							#session.usucodigo#,
						   #session.usucodigo#
						   
					from AFMovsEmpresasD a		
							
							inner join Activos b
								on a.Aid = b.Aid
							   and a.Ecodigo_O = b.Ecodigo
							
							inner join AFResponsables c
								on c.Aid = b.Aid
							   and c.Ecodigo = b.Ecodigo
							   and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between c.AFRfini and c.AFRffin
										
							inner join CFuncional d
								on a.CFid = d.CFid
							   and a.Ecodigo = d.Ecodigo										
															
					where a.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
					  and a.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_empresa#">																			
				</cfquery>

				<!--- *********** C O N T A B I L I Z A C I O N   D E   R E T I R O S **************************** --->
				
				<!--- Retira los Activos de la empresa origen --->
				<cfinvoke 
					component="sif.Componentes.AF_ContabilizarRetiro" 
					method="AF_ContabilizarRetiro" 
					returnvariable="rsResultadosRT"
					Ecodigo="#Lvar_empresa#"
					Conexion="#session.dsn#"
					Usucodigo="#session.usucodigo#"					
					AGTPid="#llave#"
					descripcion="Activo Fijo: Retiro por traslado"
					TransaccionActiva="true"
					IPregistro="#session.sitio.ip#"
					AstInter="true"
					EmpresaOrigen="#Session.Ecodigo#"/>				

				<!--- *********** C O N T A B I L I Z A C I O N   D E   A D Q U I S I C I O N *********************** --->

				<cfquery datasource="#session.dsn#" name="rsTotalLn">
					Select #Session.Ecodigo# as Ecodigo,
						   'TA' as EAcpidtrans,
						   {fn concat(<cf_dbfunction name="to_char" datasource="#session.dsn#" args="b.Ocodigo">,'-#Vper##RepeatString('0',2-len(Vmes))#-#form.AFMovsID#-#Lvar_empresa#')} as EAcpdoc,						   
						   1 as EAcplinea
					from AFMovsEmpresasD a
							inner join CFuncional b
								on a.CFid = b.CFid
								  and a.Ecodigo = b.Ecodigo
					where a.AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
					  and a.Ecodigo_O = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_empresa#">					
					group by b.Ocodigo
				</cfquery>
				
				<!--- Proceso de inclusion de los activos --->
				<cfloop query="rsTotalLn">				
					
					<cfset Lvarln_Ecodigo = rsTotalLn.Ecodigo>
					<cfset Lvarln_EAcpidtrans = rsTotalLn.EAcpidtrans>
					<cfset Lvarln_EAcpdoc = rsTotalLn.EAcpdoc>
					<cfset Lvarln_EAcplinea = rsTotalLn.EAcplinea>
					
					<cfquery name="rstesting" datasource="#session.dsn#">
					UPDATE EAadquisicion 
					set EAstatus = 1
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvarln_Ecodigo#">
					  and EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvarln_EAcpidtrans#">
					  and EAcpdoc = <cfqueryparam cfsqltype="cf_sql_char" value="#Lvarln_EAcpdoc#">
					  and EAcplinea	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvarln_EAcplinea#">
					</cfquery>					
				
					<cfinvoke 
						component="sif.Componentes.AF_AltaActivosAdq" 
						method="AF_AltaActivosAdq" 
						Contabilizar="true"
						EAcpidtrans="TA"
						EAcpdoc="#Lvarln_EAcpdoc#"
						EAcplinea="#Lvarln_EAcplinea#"
						TransaccionActiva="true"
						AstInter="true"
						EmpresaDt="#Lvar_empresa#"
						/>

				</cfloop>
				
			</cfloop>
			
			<!--- *********************************************************************************************** --->
			<!--- **************************** Se actualizan los datos de la relacion *************************** --->
			<!--- *********************************************************************************************** --->
					
			<cfquery name="RS_Motivo" datasource="#session.DSN#">
				UPDATE AFMovsEmpresasE
				set AFMovsEstado      = 1,
					AFMovsPeriodo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Vper#">,
					AFMovsMes 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Vmes#">,
					AFMovsFechaPosteo = <cf_dbfunction name="now">,
					AFMovsUsuPosteo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where AFMovsID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMovsID#">
				and Ecodigo =  #session.Ecodigo# 	  
			</cfquery>
			
		</cftransaction>				
		<cfset params = "?AFMovsID=#form.AFMovsID#">
		<cflocation url="AF_ListaTraslados.cfm#params#">
	</cfif>
</cfif>

