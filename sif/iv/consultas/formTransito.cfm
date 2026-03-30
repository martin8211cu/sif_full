<cffunction name="get_articulo" access="public" returntype="query">
	<cfargument name="acodigo" type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_articulo" datasource="#session.DSN#" >
		select rtrim(Adescripcion) as Adescripcion from Articulos
		where Ecodigo =  #Session.Ecodigo# 
		and Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#acodigo#">
	</cfquery>
	<cfreturn #rsget_articulo#>
</cffunction>

<cffunction name="get_acodigo" access="public" returntype="query">
	<cfargument name="aid" type="numeric" required="true" default="<!--- Código de la línea de Título --->">
	<cfquery name="rsget_acodigo" datasource="#session.DSN#" >
		select Acodigo from Articulos
		where Ecodigo =  #Session.Ecodigo# 
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#aid#">
	</cfquery>
	<cfreturn #rsget_acodigo#>
</cffunction>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo =  #Session.Ecodigo# 
</cfquery>

<!--- ======================================================================================================================= --->
<!---   														Rangos														  --->		
<!--- ======================================================================================================================= --->

<!--- 	Validacion de Rangos, valida lo siguiente: 
		1. Asume que Aid, siempre viene, pues hay otras consultas que llaman a esta consulta, y 
		   le mandan el Aid. ( esto podria cambiarse para que devuelva todos los articulos existentes )
		2. Si no existe form.AidF, a la variable acodigof le asigna el valor de acodigoi
		3. Si existe un rango de articulos, debe validar ese rango desde un articulo menor hasta uno mayor, por el Acodigo.
		   Esto para que el select de articulos devuelva los articulos en el orden en que el conlis de seleccion los muestra, 
		   y el conlis de seleccion lo hace por Acodigo y NO por Aid
--->
<cfset acodigoi = "">
<cfset acodigof = "">
<cfif isdefined("form.Aid") and form.Aid neq "" >
	<cfset acodigoi = #get_acodigo(form.Aid).Acodigo# >
</cfif>

<cfif isdefined("form.AidF") and form.AidF neq "" >
	<cfset acodigof = #get_acodigo(form.AidF).Acodigo# >
</cfif>
<cfif isdefined("url.Aid")>
	<cfset acodigof = acodigoi>
</cfif>
<cfif isdefined("url.fecha1")>
	<cfset form.fecha1 = url.fecha1>
</cfif>
<cfif isdefined("url.fecha2")>
	<cfset form.fecha2 = url.fecha2>
</cfif>
<cfif isdefined("url.ckPend")>
	<cfset form.ckPend = url.ckPend>
</cfif>

<cfif acodigoi neq "" and acodigof neq "" and (#compareNoCase(acodigoi, acodigof)#  eq 1) >
	<cfset tmp      = acodigoi>
	<cfset acodigoi = acodigof>	
	<cfset acodigof = tmp>	
</cfif>

<!--- ======================================================================================================================= --->
<!--- ======================================================================================================================= --->

<form name="form1" method="post">
<cfif isdefined("form.toExcel")>
	<cfcontent type="application/msexcel">
	<cfheader 	name="Content-Disposition" 
	value="attachment;filename=InventarioEnTransito_#session.Usucodigo#_#LSDateFormat(now(), 'yyyymmdd')#_#LSTimeFormat(now(),'HHMmSs')#.xls" >
</cfif>
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>            
  <table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
    <tr> 
      <td colspan="11" class="tituloAlterno" align="center"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></td>
    </tr>
    <tr> 
      <td colspan="11">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="11" align="center"><b>Consulta de Art&iacute;culos de Inventario
          en Tr&aacute;nsito</b></td>
    </tr>
	<cfoutput> 
		<tr>
			<td colspan="11" align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
		</tr>
		<tr>
			<td colspan="11" align="center"><b>Rango de fecha del embarque:</b> <cfif isdefined('form.fecha1') and len(trim(form.fecha1)) NEQ 0>Del #LSDateFormat(form.fecha1, 'dd/mm/yyyy')# &nbsp; al &nbsp;  </cfif><cfif isdefined('form.fecha2') and len(trim(form.fecha2)) NEQ 0>#LSDateFormat(form.fecha2, 'dd/mm/yyyy')# &nbsp; </cfif></td>
		</tr>
		<cfif isdefined('form.ckPend')>
			<tr>
				<td colspan="11" align="center"><b>Solo art&iacute;culos con saldo pendiente</b></td>
			</tr>
		</cfif>
	</cfoutput>
	  <cfset filtro = "">
	  <cf_dbfunction name="to_date00"	args="t.Tfecha" returnvariable="Tfecha"><!---Se le quita la Hora--->
	  <cf_dbfunction name="to_date"	args="#form.fecha1#" returnvariable="fecha1">
	  <cf_dbfunction name="to_date"	args="#form.fecha2#" returnvariable="fecha2">

		<cfquery name="rsRango" datasource="#session.DSN#">
			select a.Aid as Aid, t.Tid as Tid
			from Articulos a
				inner join Transito t
					on a.Ecodigo = t.Ecodigo
			       and a.Aid = t.Aid	
			where a.Ecodigo= #Session.Ecodigo#  
			and a.Aid in ( select distinct Aid 
						 from Existencias 
						 where Ecodigo =  #Session.Ecodigo#  
					   )
			<cfif acodigoi neq "" and acodigof neq "">
				and a.Acodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#acodigoi#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#acodigof#">
			<cfelseif acodigoi neq "">
				and a.Acodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#acodigoi#">
			<cfelseif acodigof neq "">
				and a.Acodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#acodigof#">
			</cfif>
			
			<cfif isdefined('form.fecha1') and len(trim(form.fecha1)) NEQ 0 and isdefined('form.fecha2') and len(trim(form.fecha2)) NEQ 0 >
				and #PreserveSingleQuotes(Tfecha)# between #PreserveSingleQuotes(fecha1)# and #PreserveSingleQuotes(fecha2)#
			<cfelseif isdefined('form.fecha1') and len(trim(form.fecha1)) NEQ 0 and isdefined('form.fecha2') and len(trim(form.fecha2)) EQ 0>	
				and #PreserveSingleQuotes(Tfecha)# >= #PreserveSingleQuotes(fecha1)#
			<cfelseif isdefined('form.fecha1') and len(trim(form.fecha1)) EQ 0 and isdefined('form.fecha2') and len(trim(form.fecha2)) NEQ 0>	
				and #PreserveSingleQuotes(Tfecha)# <= #PreserveSingleQuotes(fecha2)#
			</cfif>
			<cfif isdefined('form.ckPend')>
				and t.Trecibido < t.Tcantidad
			</cfif>	
			and a.Ecodigo = t.Ecodigo
			and a.Aid = t.Aid		
			order by upper(a.Acodigo)			
		</cfquery>

		<cfoutput> 
		<cfset codigoArt = "">
		<cfloop query="rsRango">
		
					<tr> 
					  <td colspan="16" class="bottomline">&nbsp;</td>
					</tr>
					<cfquery name="rsArticulo" datasource="#Session.DSN#">
						select 	a.Aid as Aid, Tid as Tid, IDdocumento ,DDlinea , Dcodigo ,CPTcodigo, Ddocumento ,SNcodigo ,DDdocref ,t.Acodigo ,
							Tembarque ,Tfecha ,Tcantidad ,Trecibido ,TcostoLinea ,Tobservacion  , a.Adescripcion, (Tcantidad - Trecibido) as Pendiente, a.Acodalterno
						from Transito t
							inner join Articulos a
								on a.Ecodigo = t.Ecodigo
							   and a.Aid = t.Aid	
						where a.Ecodigo =  #Session.Ecodigo# 
							and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Aid#">
							and t.Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Tid#">
						order by t.Acodigo
					</cfquery>
					
					<cfif codigoArt NEQ rsRango.Aid>
						<tr> 
							<td  colspan="7" class="tituloListas" align="left"><div align="center"><font size="3">#rsArticulo.Adescripcion#</font></div></td>
						</tr>
					</cfif>

					<cfif rsRango.Currentrow EQ 1>
					  <tr> 
						<td nowrap> <div align="center"><strong>Embarque:</strong></div></td>
						<td ><div align="center"><strong>Fecha:</strong></div></td>
						<td nowrap><div align="center"><strong>C&oacute;digo:</strong></div></td>						
						<td nowrap> <div align="center"><strong>C&oacute;digo Alterno:</strong></div></td>
						<td nowrap> <div align="center"><strong>Cantidad del Embarque:</strong></div></td>
						<td ><div align="center"><strong>Cantidad Recibida:</strong></div></td>
						<td width="13%" nowrap><div align="center"><strong>Pendiente de Recibir:</strong></div></td>
						
					  </tr>
					 </cfif>
					  <tr> 
						<td><div align="center">#rsArticulo.Tembarque#</div></td>
						<td ><div align="center">#LSDateFormat(rsArticulo.Tfecha, 'dd/mm/yyyy')#</div></td>
						<td ><div align="center">#rsArticulo.Acodigo#</div></td>
						<td ><div align="center">#rsArticulo.Acodalterno#</div></td>
						<td ><div align="right">#LSCurrencyFormat(rsArticulo.Tcantidad,"none")#</div></td>
						<td ><div align="right">#LSCurrencyFormat(rsArticulo.Trecibido,"none")#</div></td>
						<td ><div align="right">#LSCurrencyFormat(rsArticulo.Pendiente,"none")#</div></td>	
					  </tr>
					  <cfset codigoArt = rsRango.Aid>
 			</cfloop>
		<cfif rsRango.Recordcount NEQ 0>
			 <tr>
				<td colspan="11" align="center">------------------ Fin del Reporte ------------------</td>
			  </tr>					
		<cfelse>
			 <tr>
				<td colspan="11" align="center">------------------ No existen embarques para es artículo, en la fecha solicitada ------------------</td>
			  </tr>					
		</cfif>	
		</cfoutput> 			
  </table>
</form>