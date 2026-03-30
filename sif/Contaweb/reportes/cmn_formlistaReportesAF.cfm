<!--- 
Listado de los Reportes que se generan despues de crear una relacion.
--->

<cfquery datasource="#session.Conta.dsn#"  name="sql" >	
	select ID_REP, AF8NUM,	AF8DES, NARCH, FECHAGEN
	from tbl_reportesdepAF
	where ESTADO = 0
</cfquery>

<cfoutput>
	<table width="100%" border="0">
		<tr>
			<td  align="center" width="5%"></td>
			<td  bgcolor="##CCCCCC" colspan="9" align="center"><strong>Listado de Reportes de Transacciones</strong></td>			
		</tr>	
		<tr>
			<td  align="center"></td>
			<td  bgcolor="##CCCCCC" align="center" width="15%"><strong>Num. Rel.</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Descripcion</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>N. Archivo</strong></td>
			<td  bgcolor="##CCCCCC" align="center"><strong>Fecha</strong></td>			
		</tr>
		
		
		<cfif sql.recordcount gt 0>
		    
			<cfloop query="sql">
				<tr>
					<td align="center"> 
					<img src="imagenes/Cfinclude.gif" onClick="BJ_ARCH('#sql.NARCH#','#sql.ID_REP#')">
					</td>
					<td  align="center">#sql.AF8NUM#</td>					
					<td  align="center">#sql.AF8DES#</td>
					<td  align="center">#DateFormat(sql.FECHAGEN,"dd/mm/yyyy")#</td>
					<td  align="center">#sql.NARCH#</td>							
				</tr>
			</cfloop>
			
		</cfif>
	</table>
</cfoutput>

<script language="javascript" type="text/javascript">
window.setInterval("location.reload()",15000);
function BJ_ARCH(archivo,llave) {
	var PARAMS = "?ARCHIVO="+archivo+"&LLAVE="+llave;
	var formato   =  "left=320,top=300,scrollbars=yes,resizable=yes,width=1,height=1"
	open("/cfmx/sif/Contaweb/reportes/cmn_bajarArchivoAF.cfm"+PARAMS,"",formato);
	window.setInterval("location.reload()",2000);

}
</script>
