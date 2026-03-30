<cfset filtroDin = "">
<cfset tituloMant = "">
<cfset titPortletForm = " ">
<cfset titPortletMenu = " ">
<cfset titLista = "">

<cfoutput>
	<cfif isdefined('form.LCid') and form.LCid NEQ '' and form.modoLoc EQ 'CAMBIO'>
		<cfquery datasource="#session.dsn#" name="rsTitulo">
			select lo.LCnombre	
				, lo.DPnivel
				, dpol.DPnombre	as divPol
				, lo.LCidPadre
				, dpolInf.DPnombre	as divPolInf
			from Localidad lo
				inner join DivisionPolitica dpol
					on dpol.Ppais=lo.Ppais
						and dpol.DPnivel=lo.DPnivel
				left outer join DivisionPolitica dpolInf
					on dpolInf.Ppais=lo.Ppais
						and dpolInf.DPnivel=lo.DPnivel + 1
						
			where lo.LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCid#">
		</cfquery>
			
		<cfif isdefined('rsTitulo') and rsTitulo.recordCount GT 0>
			<cfif rsTitulo.LCidPadre EQ ''>
				<cfset filtroDin = " and LCidPadre is null">				
			<cfelse>
				<cfset filtroDin = " and LCidPadre=#rsTitulo.LCidPadre#">
			</cfif>
		
			<cfset titLista = "Lista de " & rsTitulo.divPol>
			<cfset titPortletForm = "Modificar " & rsTitulo.LCnombre>
			<cfset tituloMant = rsTitulo.divPol & ': ' & rsTitulo.LCnombre>						
		</cfif>
	<cfelse>
		<cfif isdefined('form.LCid') and form.LCid NEQ ''>
			<cfquery datasource="#session.dsn#" name="rsTitulo">
				select lo.LCnombre	
					, lo.DPnivel
					, dpol.DPnombre	as divPol
					, lo.LCidPadre
					, dpolInf.DPnombre	as divPolInf
				from Localidad lo
					inner join DivisionPolitica dpol
						on dpol.Ppais=lo.Ppais
							and dpol.DPnivel=lo.DPnivel
					left outer join DivisionPolitica dpolInf
						on dpolInf.Ppais=lo.Ppais
							and dpolInf.DPnivel=lo.DPnivel + 1
							
				where lo.LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCid#">
			</cfquery>			
			<cfset filtroDin = " and LCidPadre=#form.LCid#">
			<cfset tituloMant = "Agregar " & rsTitulo.divPolInf>
			<cfset titLista = "Lista de " & rsTitulo.divPolInf>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="rsPNivel">
				Select DPnombre
				from DivisionPolitica 
				where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.pais#">
					and DPnivel = 1
			</cfquery>		
			<cfset filtroDin = " and LCidPadre is null">
			<cfif isdefined('rsPNivel') and rsPNivel.recordCount GT 0>
				<cfset tituloMant = "Agregar " & rsPNivel.DPnombre>
				<cfset titLista = "Lista de " & rsPNivel.DPnombre>
			 </cfif>			
		</cfif>
	</cfif>
</cfoutput>

<cf_web_portlet_start tipo="box">
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td colspan="3" align="center" class="menuhead">
			<cfoutput>#tituloMant#</cfoutput>
		</td>
	  </tr>
	  <tr>
		<td align="center" valign="top" width="30%">
			<cf_web_portlet_start titulo="#titLista#" tipo="bold" width="100%">
				<cfinclude template="Localidad-listas.cfm">
			<cf_web_portlet_end>		
		</td>
		<td align="center" valign="top" width="50%">
 			<cf_web_portlet_start titulo="#titPortletForm#" tipo="bold" width="100%">
				<cfinclude template="Localidad-form.cfm">
			<cf_web_portlet_end>
		</td>
		<td align="center" valign="top" width="20%">
			<cf_web_portlet_start titulo="Opciones" tipo="bold" width="100%">
				<cfinclude template="Localidad-menu.cfm">
			<cf_web_portlet_end>
		</td>
	  </tr>
	</table>
<cf_web_portlet_end>