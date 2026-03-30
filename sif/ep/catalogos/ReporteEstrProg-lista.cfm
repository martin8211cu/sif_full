
<cfset filtro = "">
<cfoutput>
<cfset campos = "">
<form name="form_2" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td valign="top">
			<cfif len(campos) gt 0>
				<cfif mid(trim(campos),len(trim(campos)),1) eq "," >
					<cfset campos = "," & mid(trim(campos),1,(len(trim(campos))-1)) & " ">
				<cfelse>
					<cfset campos = "," & campos & " ">
				</cfif>
			</cfif>
            <cfset params ="">
			<cfif isdefined("Form.ID_RepEstrProg") and Len(Trim(Form.ID_RepEstrProg))>
                <cfset params =" ?ID_RepEstrProg = " & Form.ID_RepEstrProg>
            </cfif>            
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"
				columnas="a.ID_RepEstrProg, a.ID_Estr, a.SPcodigo, b.SPdescripcion, c.EPcodigo as RepCodigo, c.EPdescripcion"
				tabla="CGReEstrProg a
                        inner join SProcesos b
                        on a.SPcodigo = b.SPcodigo
                        inner join CGEstrProg c
                        on a.ID_Estr=c.ID_Estr"                        
				filtro="1=1 #PreserveSingleQuotes(filtro)# order by a.SPcodigo,RepCodigo"
                
				desplegar="SPcodigo,SPdescripcion,RepCodigo,EPdescripcion"
                
				etiquetas="Clave Reporte,Reporte,Clave Est.Prog.,Estructura Program&aacute;tica"
				formatos="S,S,S,S"
				align="left,left,left,left"
				checkboxes="N"
				ira="ReporteEstrProg.cfm#params#"
				nuevo="ReporteEstrProg.cfm#params#"
				showLink="true"
				showemptylistmsg="true"
				incluyeform="false"
				formname="form_2"
				keys="ID_RepEstrProg"
				mostrar_filtro="true"
				filtrar_automatico="true"
				filtrar_por="a.SPcodigo,b.SPdescripcion,RepCodigo,c.EPdescripcion,' '"
				maxrows="15"
				navegacion="#navegacion#"
				/>
		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
</form>    
</cfoutput>

