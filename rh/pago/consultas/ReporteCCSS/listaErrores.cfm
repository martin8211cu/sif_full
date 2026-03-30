<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Errores_CCSS"
	Default="Errores CCSS"
	returnvariable="LB_Errores_CCSS"/>
<cfoutput>
	<cfset LvarFileName = "ErroresCCSS_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<cf_htmlReportsHeaders 
		title="#LB_Errores_CCSS#" 
		filename="#LvarFileName#"
		irA="GrandesClientesCCSS.cfm" 
		>
	<cfif not isdefined("form.btnDownload")>
		<cf_templatecss>
	</cfif>	
	
  <table width="100%" border="0" cellspacing="1" cellpadding="1">
	  <tr >
		<td  bgcolor="##CCCCCC" align="center" colspan="3"><b><cf_translate  key="LB_titulo">Los siguientes erorres deben de corregirse para poder generar el archivo de grandes clientes</cf_translate></b></td>
	  </tr>
	  <cfset corte = -1>
	  <cfloop query="err">
	  	<cfif trim(err.ErrorNum) neq trim(corte)>
			<cfset corte = err.ErrorNum>
				 <tr>
				    <td colspan="3">&nbsp;</td>
				 </tr>
				<tr >
					<cfswitch expression="#corte#">
						<cfcase value="1">
								<td  bgcolor="##CCCCCC" align="center" colspan="3"><b><cf_translate  key="LB_1">Par&aacute;metros Generales</cf_translate></b></td>
						</cfcase>
						<cfcase value="2">
								<td bgcolor="##CCCCCC" align="center"  colspan="3"><b><cf_translate  key="LB_2">Acciones de Personal de tipo Permiso</cf_translate></b></td>
						</cfcase>	
						<cfcase value="3">
								<td  bgcolor="##CCCCCC"align="center"  colspan="3"><b><cf_translate  key="LB_3">Acciones de Personal de tipo Incapacidad</cf_translate></b></td>
						</cfcase>
						<cfcase value="4">
								<td bgcolor="##CCCCCC" align="center"  colspan="3"><b><cf_translate  key="LB_4">Empleados con el n&uacute;mero seguro social sin definir </cf_translate></b></td>
						</cfcase>
						<cfcase value="5">
								<td bgcolor="##CCCCCC" align="center"  colspan="3"><b><cf_translate  key="LB_5">Puestos que no tienen definido la ocupaci&oacute;n ( Hom&oacute;logo de la caja )</cf_translate></b></td>
						</cfcase>
						<cfcase value="6">
								<td bgcolor="##CCCCCC" align="center"  colspan="3"><b><cf_translate  key="LB_5">Otras validaciones</cf_translate></b></td>
						</cfcase>				
					</cfswitch>
				</tr>
		</cfif>
		<tr>
			<td  width="20%" nowrap="nowrap" colspan="1">#err.Codigo#</td>
			<td colspan="2">#err.Mensaje#</td>
		</tr>
	  </cfloop>
	<tr>
		<td  bgcolor="##CCCCCC" align="center" colspan="3"><cf_translate  key="LB_fin2">****** Fin ****** </cf_translate></td>
	</tr>
</table>

</cfoutput>
	