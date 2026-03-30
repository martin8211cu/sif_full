<cfquery name="rsFormD" datasource="#Session.DSN#">
	Select CPCVPid,CPformatoPadre
	from CPCtaVinculadaPadres det
		inner join CPCtaVinculada cp
			on cp.CPCVid = det.CPCVid
	where det.CPCVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCVid#">
</cfquery>

<!--- Variable para pintar las cajas para agregar las cuentas Padres para las cuentas vinculadas --->
<cfset numCajas = 5>

<input type="hidden" name="idBorrar" value="">
<input type="hidden" name="cantDets" value="<cfoutput>#numCajas#</cfoutput>"><!--- Para hacer el ciclo de inserciones en el SQL --->
<table border="0" cellpadding="0" cellspacing="0" align="center">
		<tr class="areaFiltro">
			<td style="width:30px;">&nbsp;</td>
			<td><strong>Cuentas Padres</strong></td>
		</tr>		
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>				
	<cfloop from="1" index="indice" to="#numCajas#">
		<tr>
			<td>&nbsp;</td>			
			<td>
				<cf_CuentaPresupuesto name="cPadre_#indice#" size="30">
			</td>				
		</tr>	
	</cfloop>	
	<cfif isdefined('rsFormD') and rsFormD.recordCount GT 0>
		<cfloop query="rsFormD">
			<cfset LvarListaNon = (CurrentRow MOD 2)>
			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				<td>
					<a href="#">
						<img border='0' alt="Eliminar Cuenta" onClick="eliminar('<cfoutput>#CPCVPid#</cfoutput>');" src='/cfmx/sif/imagenes/Borrar01_S.gif'>
					</a>
				</td>
				<td>
					<cfoutput>#trim(CPformatoPadre)#</cfoutput>
				</td>				
			</tr>
		</cfloop>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>			
	</cfif>
</table> 

<script language="JavaScript">
 	function eliminar(valor){
		if(confirm('Desea eliminar esta Cuenta Padre ?')){
			document.form1.idBorrar.value = valor;
			document.form1.submit();
		}else{
			document.form1.idBorrar.value = '';
		}
	}
</script> 

