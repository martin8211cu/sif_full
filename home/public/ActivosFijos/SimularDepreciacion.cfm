<style>
	#tableAF{
  border: 0px solid black;
  border-spacing: 0px;
}

#tableAF thead tr{
  font-family: Arial, monospace;
  font-size: 14px;
}

#tableAF thead tr th{
  border-bottom: 2px solid black;
  border-top: 1px solid black;
  margin: 0px;
  padding: 2px;
  background-color: #cccccc;
}

#tableAF tr {
  font-family: arial, monospace;
  color: black;
  font-size:12px;
  background-color: white;
}

#tableAF tr.odd {
  background-color: #AAAAAA;
}

#tableAF tr td, th{
  border-bottom: 1px solid black;
  padding: 2px;
}



</style>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='SIMULACION DE ENTRADA'>	
<cfform name="form1" action="SimularDepreciacion.cfm">
	<table border="0" width="100%">
		<tr>
			<td align="center" colspan="3">
				SIMULACION DE DEPRECIACIÓN EN LINEA RECTA
			</td>
		</tr>
		<tr>
			<td align="center" colspan="3">
				PLACA:
				<cfinput name="Aplaca">
		        <cfinput type="submit" class="btnNormal" name="Simular" value="SIMULAR">
		  </td>
	</table>
</cfform>
<cf_web_portlet_end>
<cfif isdefined('form.Aplaca')>
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
		select Pvalor as value
			from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and Pcodigo = 50
		  and Mcodigo = 'GN'
	</cfquery>
	<cfquery name="rsMes" datasource="#session.dsn#">
		select Pvalor as value
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Pcodigo = 60
			and Mcodigo = 'GN'
	</cfquery>
	<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
	<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("h",23,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("n",59,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("s",59,rsFechaAux.value)>
	<cfquery name="rsMetodoValido" datasource="#session.dsn#">
		select Pvalor as MetodoDepreciacion
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		  and Pcodigo = 245
	</cfquery>
	<cfif isdefined('rsMetodoValido') and rsMetodoValido.recordcount GT 0>
			<cfset MetodoDepreciacion = rsMetodoValido.MetodoDepreciacion>
	<cfelse>
			<cfset MetodoDepreciacion = 1>
	</cfif>
	<cfquery name="rsAF" datasource="#session.dsn#">
		select Astatus,Aid, Afechainidep from Activos where Ecodigo = #session.Ecodigo# and Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Aplaca#">
	</cfquery>
	<cfquery name="rsAFFecha" datasource="#session.dsn#">
		select Astatus from Activos where Ecodigo = #session.Ecodigo# and Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Aplaca#">
		and <cf_dbfunction name="to_date00" args="Afechainidep"> <= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">	
	</cfquery>
	<cfquery name="rsAFTrans" datasource="#session.dsn#">
		select a.Astatus 
			from Activos a 
				inner join TransaccionesActivos AFT 
					on AFT.Aid = a.Aid 
		where AFT.IDtrans = 4 
	      and AFT.TAperiodo = #rsPeriodo.value#
		  and AFT.TAmes	    = #rsMes.value#
		  and a.Ecodigo     = #session.Ecodigo# 
		  and a.Aplaca      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Aplaca#">
	</cfquery>
	<cfquery name="rsCat" datasource="#session.dsn#">
		select a.Astatus 
			from Activos a 
				inner join ACategoria ac 
					 on ac.Ecodigo = a.Ecodigo
					and ac.ACcodigo = a.ACcodigo
				    and ac.ACmetododep = 1 	
		where a.Ecodigo     = #session.Ecodigo# 
		  and a.Aplaca      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Aplaca#">
	</cfquery>
	<cfquery name="rsAFSaldos" datasource="#session.dsn#">
		select AFS.AFSdepreciable, AFSvutiladq,AFSvutilrev,AFSsaldovutiladq,AFSsaldovutilrev,Avalrescate,
		AFSvaladq,AFSvalmej,AFSvalrev,AFSdepacumadq,AFSdepacummej,AFSdepacumrev,
		<cf_dbfunction name="datediff" args="AF.Afechainidep,#rsFechaAux.value#,MM"> CantidadMeses
			from Activos AF 
				inner join AFSaldos AFS 
					 on AFS.Aid 		= AF.Aid 
					and AFS.AFSperiodo 	= #rsPeriodo.value#
					and AFS.AFSmes 		= #rsMes.value#
		where AF.Ecodigo     = #session.Ecodigo# 
		  and AF.Aplaca      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Aplaca#">
	</cfquery>
	<cfquery name="rsAFTransP" datasource="#session.dsn#">
		select a.Astatus 
			from Activos a 
				inner join ADTProceso TP
					on TP.Aid = a.Aid 
		where TP.IDtrans = 4 
	      and TP.TAperiodo = #rsPeriodo.value#
		  and TP.TAmes	    = #rsMes.value#
		  and a.Ecodigo     = #session.Ecodigo# 
		  and a.Aplaca      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Aplaca#">
	</cfquery>
	<cfquery name="mesesEnCero" datasource="#session.dsn#">
		select count(1) cantidad
			from AFSaldos AFS 
				inner join Activos AF
					on AF.Aid = AFS.Aid
		 where (
		          AFS.AFSperiodo > <cf_dbfunction name="date_part"	args="YYYY,AF.Afechainidep"> or 
	             (AFS.AFSperiodo = <cf_dbfunction name="date_part"	args="YYYY,AF.Afechainidep"> and  AFS.AFSmes >= <cf_dbfunction name="date_part"	args="MM,AF.Afechainidep">)
                )
				and AFS.AFSsaldovutiladq <= 0
				<cfif len(trim(rsAF.Aid))>and AFS.Aid = #rsAF.Aid#<cfelse>and 1=2</cfif>
	</cfquery>
	<cfquery name="mesesEnCero2" datasource="#session.dsn#">
		select count(1) cantidad
			from AFSaldos AFS 
				inner join Activos AF
					on AF.Aid = AFS.Aid
		 where (
		          AFS.AFSperiodo > <cf_dbfunction name="date_part"	args="YYYY,AF.Afechainidep"> or 
	             (AFS.AFSperiodo = <cf_dbfunction name="date_part"	args="YYYY,AF.Afechainidep"> and  AFS.AFSmes >= <cf_dbfunction name="date_part"	args="MM,AF.Afechainidep">)
				)
				 and not exists(select 1 
					from TransaccionesActivos AFT 
				   where AFT.Aid       = AFS.Aid 
					 and AFT.IDtrans   = 4
					 and AFT.TAperiodo = AFS.AFSperiodo
					 and AFT.TAmes	   = AFS.AFSmes)
				and AFS.AFSsaldovutiladq <= 0
				<cfif len(trim(rsAF.Aid))>and AFS.Aid = #rsAF.Aid#<cfelse>and 1=2</cfif>
	</cfquery>
	
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='INFORMACIÓN NESESARIA PARA LA DEPRECIACIÓN'>	
	<cfoutput>
		<table border="3" bordercolor="##0033CC" align="center" bgcolor="##CCFFFF">
			<cfif rsAF.recordcount EQ 0>
				<tr>
					<td>
						EL ACTIVO NO EXISTE(NO SALDRIA EN LA DEP.)<cfabort>
					</td>
				</tr>
			</cfif>
			<cfif rsAF.Astatus EQ 60>
				<tr>
					<td>
						EL ACTIVO ESTA RETIRADO(NO SALDRIA EN LA DEP.)<cfabort>
					</td>
				</tr>
			</cfif>
			<tr>
				<td>Placa:</td>
				<td>
					#form.Aplaca#
				</td>
			</tr>
			<tr>
				<td>Mes Auxiliar:</td>
				<td>
					#rsPeriodo.value#
				</td>
			</tr>
			<tr>
				<td>Periodo Auxiliar:</td>
				<td>
					#rsMes.value#
				</td>
			</tr>
			<tr>
				<td>Fecha Auxiliares:</td>
				<td>
					#rsFechaAux.value#
				</td>
			</tr>
			<!---Fecha de inicio de depreciacion--->
			<tr>
				<td>Fecha de Inicio de Depreciación:</td>
				<td>
					#rsAF.Afechainidep#
				</td>
			</tr>
			<tr>
				<td>Metodo Depreciación:</td>
				<td>
					<cfif MetodoDepreciacion EQ 1>Linea Recta
					<cfelseif MetodoDepreciacion EQ 2>Linea Recta/Suma de Digistos
					<cfelseif MetodoDepreciacion EQ 3>Suma de Digistos
					<cfelse>ERROR NO HAY METODO DE DEPRECIACION</cfif>
				</td>
			</tr>
			
			<cfif rsAFFecha.recordcount EQ 0>
				<tr>
					<td>
						EL ACTIVO AUN NO COMIENZA A DEPRECIARSE(NO SALDRIA EN LA DEP.)<cfabort>
					</td>
				</tr>
			</cfif>
			<cfif rsAFTrans.recordcount NEQ 0>
				<tr>
					<td>
						Ya depreciado este MES:
					</td>
					<td >
						SI, NO SALDRIA EN LA DEP
					</td>
				</tr>
				<cfabort>
			</cfif>
			<cfif rsCat.recordcount EQ 0>
				<tr>
					<td>
						LA CATEGORIA DEL ACTIVO NO DEPRECIA EN LINEA RECTA(NO SALDRIA EN LA DEP.)<cfabort>
					</td>
				</tr>
			</cfif>
			<cfif rsAFSaldos.recordcount EQ 0>
				<tr>
					<td>
						No SE ENTRARON SALDOS DEL ACTIVO PARA EL PERIDO/MES AUXILIAR(NO SALDRIA EN LA DEP.)<cfabort>
					</td>
				</tr>
			</cfif>
			<cfif rsAFSaldos.AFSdepreciable EQ 0>
				<tr>
					<td colspan="2">
						EL ACTIVO ES NO DEPRECIABLE(NO SALDRIA EN LA DEP.)<cfabort>
					</td>
				</tr>
			</cfif>
			<!---Vida Util de adquisicion--->
			<tr>
				<td>
					Vida Util de Adquisición: 
				</td>
				<td>
					#rsAFSaldos.AFSvutiladq# meses
				</td>
			</tr>
			<!---Vida Util de Reevaluacion--->
			<tr>
				<td>
					Vida Util de Revaluacion: 
				</td>
				<td>
					#rsAFSaldos.AFSvutilrev# meses
				</td>
			</tr>
			<!---Saldo de vida Util de Adquision--->
			<tr>
				<td>
					saldo de Vida Util de Adquisicion: 
				</td>
				<td>
					#rsAFSaldos.AFSsaldovutiladq# meses
				</td>
			</tr>
			<!---Saldo de vida Util de Reevaluacion--->
			<tr>
				<td>
					saldo de Vida Util de Revaluación: 
				</td>
				<td>
					#rsAFSaldos.AFSsaldovutilrev# meses
				</td>
			</tr>
			<!---Meses depreciados a la fecha--->
			<tr>
				<td>
					Meses depreciados a la fecha(Por sistema y Cargados): 
				</td>
				<td>
					<cfset meseDepreciados = rsAFSaldos.AFSvutiladq - rsAFSaldos.AFSsaldovutiladq>
					#rsAFSaldos.AFSvutiladq#-#rsAFSaldos.AFSsaldovutiladq# = #meseDepreciados# meses
				</td>
			</tr>
			<!---Cantidad de Meses desde el Inicio de Depreciacion al periodo/mes Auxiliar--->
			<tr>
				<td>Cantidad de Meses desde el Inicio de Depreciacion al periodo/mes Auxiliar
				</td>
				<td>#rsAFSaldos.CantidadMeses# meses
				</td>
			</tr>
			<!---Cantidad de Meses con saldo de Vida Util en Cero--->
			<tr>
				<td>Cantidad de Meses con saldo de Vida Util en Cero:
				</td>
				<td>#mesesEnCero.cantidad# meses
				</td>
			</tr>
			<!---Cantidad de Meses con saldo de Vida Util en Cero que no hallan recibido Depreciación--->
			<tr>
				<td>Cantidad de Meses con saldo de Vida Util en Cero que no hallan recibido Depreciación:
				</td>
				<td>#mesesEnCero2.cantidad# meses
				</td>
			</tr>
			<!---Valor de Rescate--->
			<tr>
				<td>
					Valor de rescate: 
				</td>
				<td>
					#rsAFSaldos.Avalrescate#
				</td>
			</tr>
			
			<cfif rsAFSaldos.AFSsaldovutiladq LTE 0 and rsAFSaldos.AFSsaldovutilrev LTE 0>
				<tr>
					<td>
						EL ACTIVO NO POSEE SALDO DE VIDA UTIL<cfabort>
					</td>
				</tr>
			</cfif>
			<cfif rsAFTransP.Recordcount NEQ 0>
				<tr>
					<td>
						DEP.pendiente de aplicar:
					</td>
					<td>
						SI, NO SALDRIA EN LA DEP
					</td>
				</tr>
			</cfif>
			<!---Valor de Adquisicion--->
			<tr>
				<td>
					Valor de Adquisicion: 
				</td>
				<td>
					#rsAFSaldos.AFSvaladq#
				</td>
			</tr>
			<!---Valor de Mejoras--->
			<tr>
				<td>
					Valor de Adquisicion: 
				</td>
				<td>
					#rsAFSaldos.AFSvalmej#
				</td>
			</tr>
			<!---Valor de Revaluación--->
			<tr>
				<td>
					Valor de Adquisicion: 
				</td>
				<td>
					#rsAFSaldos.AFSvalrev#
				</td>
			</tr>
			<!---Depreciación Acumulada de la Adquisición--->
			<tr>
				<td>
					Depreciación Acumulada de la Adquisición: 
				</td>
				<td>
					#rsAFSaldos.AFSdepacumadq#
				</td>
			</tr>
			<!---Depreciación Acumulada de la Mejora--->
			<tr>
				<td>
					Depreciación Acumulada de la Mejora: 
				</td>
				<td>
					#rsAFSaldos.AFSdepacummej#
				</td>
			</tr>
			<!---Depreciación Acumulada de la Reevaluación--->
			<tr>
				<td>
					Depreciación Acumulada de la Reevaluación: 
				</td>
				<td>
					#rsAFSaldos.AFSdepacumrev#
				</td>
			</tr>
		</table>
	</cfoutput>
<cf_web_portlet_end>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='SIMULACION DE LA DEPRECIACIÓN DE ADQUISICIÓN'>	
	<cfoutput>
	<table align="center">
		<tr>
			<td align="center">
				<img src="lineaRectaAdq.jpg" />
			</td>
		</tr>
		<tr>
			<td>
				<cfset resultXMes = (rsAFSaldos.AFSvaladq - rsAFSaldos.Avalrescate -rsAFSaldos.AFSdepacumadq) / rsAFSaldos.AFSsaldovutiladq>
				<cfset MesesADepreciar =(rsAFSaldos.CantidadMeses- mesesEnCero2.cantidad) +1 - ((rsAFSaldos.AFSvutiladq - mesesEnCero2.cantidad) - rsAFSaldos.AFSsaldovutiladq) >
				<cfset resultTotal = resultXMes * MesesADepreciar>
				= [(#rsAFSaldos.AFSvaladq# - #rsAFSaldos.Avalrescate# -#rsAFSaldos.AFSdepacumadq#) / #rsAFSaldos.AFSsaldovutiladq#] * [(#rsAFSaldos.CantidadMeses#- #mesesEnCero2.cantidad#) +1 - ((#rsAFSaldos.AFSvutiladq#- #mesesEnCero2.cantidad#)- #rsAFSaldos.AFSsaldovutiladq#)]<br />
				= #resultXMes# * #MesesADepreciar#<br />
				= #resultTotal#
			</td>
		</tr>
	</table>
	</cfoutput>
<cf_web_portlet_end>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='SIMULACION DE LA DEPRECIACIÓN DE MEJORA'>	
<cfoutput>	
	<table align="center">
		<tr>
			<td align="center">
				<img src="lineaRectaMej.jpg" />
			</td>
		</tr>
		<tr>
			<td>
				<cfset resultXMes = (rsAFSaldos.AFSvalmej - rsAFSaldos.AFSdepacummej) / rsAFSaldos.AFSsaldovutiladq>
				<cfset MesesADepreciar =(rsAFSaldos.CantidadMeses- mesesEnCero2.cantidad) +1 - ((rsAFSaldos.AFSvutiladq - mesesEnCero2.cantidad) - rsAFSaldos.AFSsaldovutiladq) >
				<cfset resultTotal = resultXMes * MesesADepreciar>
				= [(#rsAFSaldos.AFSvalmej# - #rsAFSaldos.AFSdepacummej#) / #rsAFSaldos.AFSsaldovutiladq#] * [(#rsAFSaldos.CantidadMeses#-#rsAFSaldos.CantidadMeses#) +1 - ((#rsAFSaldos.AFSvutiladq#-#rsAFSaldos.CantidadMeses#) - #rsAFSaldos.AFSsaldovutiladq#)]<br />
				= #resultXMes# * #MesesADepreciar#<br />
				= #resultTotal#
			</td>
		</tr>
	</table>
</cfoutput>	
<cf_web_portlet_end>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='SIMULACION DE LA DEPRECIACIÓN DE REVALUACIÓN'>	
	<cfoutput>	
	<table align="center">
		<tr>
			<td align="center">
				<img src="lineaRectaRev.jpg" />
			</td>
		</tr>
		<tr>
			<td>
				<cfset resultXMes = (rsAFSaldos.AFSvalrev - rsAFSaldos.AFSdepacumrev) / rsAFSaldos.AFSsaldovutilrev>
				<cfset MesesADepreciar = (rsAFSaldos.CantidadMeses-mesesEnCero2.cantidad) +1 - ((rsAFSaldos.AFSvutilrev -mesesEnCero2.cantidad)- rsAFSaldos.AFSsaldovutilrev)>
				<cfset resultTotal = resultXMes * MesesADepreciar>
				= [(#rsAFSaldos.AFSvalrev# - #rsAFSaldos.AFSdepacumrev#) / #rsAFSaldos.AFSsaldovutilrev#] * [(#rsAFSaldos.CantidadMeses#-#mesesEnCero2.cantidad#) +1 - ((#rsAFSaldos.AFSvutilrev#-#mesesEnCero2.cantidad#) - #rsAFSaldos.AFSsaldovutilrev#)]<br />
				= #resultXMes# * #MesesADepreciar#<br />
				= #resultTotal#
			</td>
		</tr>
	</table>
</cfoutput>	
<cf_web_portlet_end>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='SALDOS'>	
	<cfoutput>	
	<table align="center" >
		<tr>
			<td>
				<cfquery name="rsSaldos" datasource="#session.dsn#">
					select AFSperiodo,AFSmes,AFSvutiladq,AFSvutilrev,AFSsaldovutiladq,AFSsaldovutilrev,AFSvaladq,AFSvalmej,AFSvalrev,AFSdepacumadq,AFSdepacummej,AFSdepacumrev
					from AFSaldos where Aid = #rsAF.Aid#
					order by Aid, AFSperiodo, AFSmes
				</cfquery>
				<table id="tableAF">
					<tr>
						<td>Periodo</td>
						<td>Mes</td>
						<td>Vida Funcional Adq</td>
						<td>Vida Funcional Rev</td>
						<td>Saldo Vida Util de Adquisición</td>
						<td>Saldo Vida Util de Revaluación</td>
						<td>Valor Aquisición</td>
						<td>Valor Mejora</td>
						<td>Valor Revaluación</td>
						<td>Dep.Acum. Aquisición</td>
						<td>Dep.Acum. Mejora</td>
						<td>Dep.Acum. Revaluación</td>
					</tr>
					<cfloop query="rsSaldos">
					<tr>
						<td>#rsSaldos.AFSperiodo#</td>
						<td>#rsSaldos.AFSmes#</td>
						<td>#rsSaldos.AFSvutiladq#</td>
						<td>#rsSaldos.AFSvutilrev#</td>
						<td>#rsSaldos.AFSsaldovutiladq#</td>
						<td>#rsSaldos.AFSsaldovutilrev#</td>
						<td>#rsSaldos.AFSvaladq#</td>
						<td>#rsSaldos.AFSvalmej#</td>
						<td>#rsSaldos.AFSvalrev#</td>
						<td>#rsSaldos.AFSdepacumadq#</td>
						<td>#rsSaldos.AFSdepacummej#</td>
						<td>#rsSaldos.AFSdepacumrev#</td>	
					</tr>
					</cfloop>
				</table>
			</td>
		</tr>
	</table>
</cfoutput>	
<cf_web_portlet_end>
</cfif>



<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
	<cfargument name="lValue" required="yes" type="any">
	<cfargument name="IValueIfNull" required="yes" type="any">
	<cfif len(trim(lValue))>
		<cfreturn lValue>
	<cfelse>
		<cfreturn lValueIfNull>
	</cfif>
</cffunction>