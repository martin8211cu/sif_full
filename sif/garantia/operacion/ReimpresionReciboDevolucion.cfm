<cf_templateheader title="GARANTIAS - HISTORICO">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reimpresión de Garantias Devueltas'>
<cfoutput>
<form name="form1" method="post" action="ReimpresionReciboDevolucionDet.cfm">
<fieldset><legend>Historico Garantías</legend>
	<table width="100%" cellpadding="2" cellspacing="0">	
		<tr>
			<td nowrap align="right"><strong>Garantías: </strong></td>
			<td align="left">	
            			                      
				<cf_conlis
					Campos="COEGEstado,COEGVersion,COEGid, CMPProceso, COEGReciboGarantia, COEGPersonaEntrega, COEGIdentificacion, COEGContratoAsociado"
					Desplegables="N,N,N,S,S,N,N,N"
					Modificables="N,N,N,S,N,N,N,N"
					Size="0,0,0,20,10,0,0,0"
					tabindex="1"
					Title="Garantías Devueltas"
					Tabla=" COHEGarantia a
					        inner join COLiberaGarantia cl
							     on a.COEGid = cl.COEGid   
							left join CMProceso b
								on b.CMPid  = a.CMPid
							left join SNegocios c
								on c.SNid = a.SNid"
					Columnas="a.COEGid, a.COEGReciboGarantia, cl.COLGfechaDevolucion, a.CMPid, a.COEGTipoGarantia, a.COEGEstado, a.COEGVersion, a.SNid, c.SNnombre, b.CMPProceso, 
                    		  case a.COEGEstado 
                              	when 1 then '1: Vigente' 
                                when 2 then '2: Edición' 
                                when 3 then '3: En proceso de Ejecución' 
                                when 4 then '4: En Ejecución' 
                                when 5 then '5: Ejecutada' 
                                when 6 then '6: En proceso Liberación' 
                                when 7 then '7: Liberada' 
                                when 8 then '8: Devuelta' 
                              end as Estado,
                              a.COEGPersonaEntrega,
                              a.COEGIdentificacion, 
                              case 
                              	when a.COEGContratoAsociado = 'N' 
                              	then  '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'  
                                else  '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' 
                              end as COEGContratoAsociado"
					Filtro=" a.Ecodigo=#session.Ecodigo# and a.COEGVersionActiva = 1 and a.COEGEstado = 8 order by a.COEGReciboGarantia "
					Desplegar="CMPProceso, SNnombre, COEGReciboGarantia, COLGfechaDevolucion,  COEGPersonaEntrega, COEGIdentificacion, COEGContratoAsociado"
					Etiquetas="Proceso, Provedor, N° Garantia, Fecha Devolución,  Persona Entrega, Identificación, Asoc Contr"
					filtrar_por="CMPProceso, SNnombre, COEGReciboGarantia, COEGid, COEGPersonaEntrega, COEGIdentificacion, COEGContratoAsociado"
					Formatos="S,S,I,S,I,U,U,U"
					Align="left,left,left,left,left,left,left,center"
					form="form1"
					Asignar="COEGVersion,COEGid, CMPProceso, COEGReciboGarantia, COEGPersonaEntrega, COEGIdentificacion, COEGContratoAsociado"
					Asignarformatos="S,S,S,S,S,S,S"
					width="875"
                    
				/>
			</td> <!---ESTA FALLANDO EL FILTRO DE IDENTIFICACION--->	
		</tr>					
		<tr>
			<td colspan="4" align="center">										
			<cf_botones values="Generar,Limpiar" names="Filtrar,Limpiar" tabindex="1" >
			</td>
		</tr>      
	</table>
</fieldset>
</form>
</cfoutput>
<cf_qforms form="form1">
    <cf_qformsrequiredfield args="COEGid,Garantía">
</cf_qforms>

<cf_web_portlet_end>
<cf_templatefooter>