<cfoutput>
	<cfset titOpc1 = "">
	<cfset titOpc2 = "">	
	
	<script language="javascript" type="text/javascript">
		function goPage(opc) {
			if(opc == 1){	//Modificar X
				<cfif isdefined('form.LCid') and form.LCid NEQ ''>
//					document.formLocalidadMenu.modoLoc.value = 'CAMBIO';
				<cfelse>
					document.formLocalidadMenu.btnNuevo.value = 'btnNuevo';
				</cfif>
			}else{
				if(opc == 2){	//Agregar X
					<cfif isdefined('form.modoLoc') and form.modoLoc EQ 'CAMBIO'>
						document.formLocalidadMenu.modoLoc.value = 'ALTA';
						document.formLocalidadMenu.LCidPadre.value = document.formLocalidadMenu.LCid.value;
						document.formLocalidadMenu.btnNuevo.value = 'btnNuevo';
					<cfelse>
						document.formLocalidadMenu.modoLoc.value = 'CAMBIO';
					</cfif>						
				}
			}
			document.formLocalidadMenu.submit();
		}
	</script>
	
	<cfif isdefined('form.LCid') and form.LCid NEQ ''>
		<cfquery datasource="#session.dsn#" name="rsMenu">
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
	</cfif>
	
	<cfif isdefined('form.LCid') and form.LCid NEQ '' and form.modoLoc EQ 'CAMBIO'>
		<cfif isdefined('rsMenu') and rsMenu.recordCount GT 0>
			<cfset titOpc1 = 'Modificar ' & rsMenu.LCnombre>
			<cfif rsTitulo.divPolInf NEQ ''>
				<cfset titOpc2 = "Agregar " & rsMenu.divPolInf & " con " & rsMenu.divPol & " " & rsMenu.LCnombre>
			</cfif>
		</cfif>		
	<cfelse>
		<cfset titOpc1 = tituloMant>
		<cfif isdefined('rsMenu') and rsMenu.recordCount GT 0>
			<cfset titOpc2 = "Modificar " & rsMenu.LCnombre>
		</cfif>
	</cfif>

	<form name="formLocalidadMenu" action="Localidad.cfm" method="get" style="margin: 0;">
		<cfinclude template="Localidad-hiddens.cfm">

		<table border="0" cellpadding="2" cellspacing="0" width="100%">
		  <!--- 1 --->
		  <tr>
			<td width="1%" align="right">
				<img src="/cfmx/saci/images/addressGo.gif" border="0">
			</td>
			<td width="1%" align="right"> <img src="/cfmx/saci/images/number1_16.gif" border="0"> </td>
			<td  nowrap>
				<a href="javascript: goPage(1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					<strong>
						#titOpc1#
					</strong>
				</a>
			</td>
		  </tr>
		  <cfif titOpc2 NEQ ''>
			  <!--- 2 --->
			  <tr>
				<td width="1%" align="right">
					&nbsp;
				</td>
				<td align="right"><img src="/cfmx/saci/images/number2_16.gif" border="0"></td>
				<td  nowrap>
					<a href="javascript: goPage(2);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						#titOpc2#
					</a>
				</td>
			  </tr>				
		  </cfif>
		</table>
	</form>
</cfoutput>
