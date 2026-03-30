<cf_templateheader title="Impuestos">
		<cf_web_portlet_start  border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Impuestos'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cfset checked   = "'<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>'" >
		<cfset unchecked = "'<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>'" >
		<cfset filtro = "">
		<cfparam name="form.cod" default="" type="string">
		<cfparam name="form.des" default="" type="string">
		<cfparam name="form.porc" default="" type="string">
		<cfif len(trim(form.cod)) gt 0>
			<cfset filtro= filtro & "and Icodigo like '%#form.cod#%'">
		</cfif>
		<cfif len(trim(form.des)) gt 0>
			<cfset filtro= filtro & "and Idescripcion like '%#form.des#%'">
		</cfif>
		<cfif len(trim(form.porc)) gt 0>
			<cfset filtro= filtro & "and Iporcentaje = #form.porc#">
		</cfif>
		<table width="80%" align="center" border="0" cellspacing="0" cellpadding="0" >
			<tr>
			<td width="45%">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr class="tituloListas">
					<td >Codigo</td>
					<td colspan="3">Descripción</td>
					<td align="right" colspan="1">Porcentaje o Valor&nbsp;Fijo</td>
					<td align="right" colspan="1">&nbsp;Compuesto</td>
					<td align="right" colspan="1">&nbsp;&nbsp;C.F.</td>
                    <td align="right" colspan="2">&nbsp;Def. Serv.&nbsp;</td>
                    <td align="right" colspan="2">&nbsp;Def. Act.&nbsp;</td>
				</tr>
				<tr class="tituloListas">
    				<form action="Impuestos.cfm" method="post" name="formI">
						<td><input type="text" name="cod" id="cod" size="8" value="<cfoutput>#form.cod#</cfoutput>" /></td>
						<td colspan="3"><input type="text" name="des" id="des" size="10" value="<cfoutput>#form.des#</cfoutput>" /></td>
						<td colspan="1"><input type="text" name="porc" id="porc" size="9" value="<cfoutput>#form.porc#</cfoutput>" /></td>
						<td colspan="1"><input type="submit" name="filtrar" id="filtrar" value="Filtrar" /></td>
						<td colspan="1">&nbsp;</td>
						<td colspan="1">&nbsp;</td>
						<td colspan="1">&nbsp;</td>
                        <td colspan="1">&nbsp;</td>
					</form>
				</tr>
			</table>
			</td>
			</tr>
			<tr> 			
			<td valign="top" width="50%" align="center"> 
				
				<cfinvoke component="sif.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="Impuestos im"/>
					<cfinvokeargument name="columnas" value="im.Icodigo, 
															im.Idescripcion,
															case im.ieps when 1 then im.ValorCalculo 
															else
															im.Iporcentaje
															end as Iporcentaje,
															case im.Icompuesto when 0 then #unchecked# else #checked# end as Icompuesto,
                                                            case when im.Icompuesto = 0 then 
													        	case im.Icreditofiscal when 0 then #unchecked# else #checked# end 
                                                    		else   
                                                            case when (SELECT count(1) FROM DImpuestos dt
                                                            WHERE dt.Icodigo= im.Icodigo 
                                                           	AND   dt.Ecodigo = im.Ecodigo 
															AND  dt.DIcreditofiscal = 1) >= 1 then #checked# else #unchecked# end 
                                                            end as Icreditofiscal,
                                                            case im.IServdefault when  0 then #unchecked# else #checked# end as IServdefault,
                                                            case im.IActdefault when  0 then #unchecked# else #checked# end as IActdefault
                                                            "/>
					
                    
                    <cfinvokeargument name="desplegar" value="Icodigo, Idescripcion, Iporcentaje, Icompuesto, Icreditofiscal, IServdefault, IActdefault"/>		
					<cfinvokeargument name="etiquetas" value="&nbsp;, &nbsp;,&nbsp; ,&nbsp;,&nbsp;,&nbsp;,&nbsp;"/>
<!---										<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Porcentaje, Compuesto, C.F."/>--->
					<cfinvokeargument name="formatos" value="S,S,U,S,S,S,S"/>
					<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by Icodigo, Idescripcion"/>
					<cfinvokeargument name="align" value="left,left,left,right,right,right,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="Impuestos.cfm"/>
					<cfinvokeargument name="keys" value="Icodigo"/>
					
					
					<!---<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>	
					<cfinvokeargument name="filtrar_por" value="Icodigo, Idescripcion,''"/>--->
					</cfinvoke>
			</td>
				<td valign="top" width="50%" align="center">
					<cfinclude template="formImpuestos.cfm">
				</td>
			</tr>
		</table>
	
<cf_web_portlet_end>
<cf_templatefooter>