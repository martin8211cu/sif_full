<cf_templateheader title="Punto de Venta - Apertura de Cajas">
	<cf_templatecss>
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Apertura de Cajas">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
				<td width="70%" valign="top">
					<!---PINTA LA LISTA IMPRESORAS --->
                    <cfinclude template="../../Utiles/sifConcat.cfm">
					<cfquery name="lista" datasource="#session.DSN#">
						select Ocodigo
							, FAM01COD, FAM01CODD, FAM09MAQ 
								, case 
									when (char_length(FAM01DES) > 14) 
										then (substring(FAM01DES,1,15) #_Cat# '...')
									else
										FAM01DES
								end as FAM01DES
							, FAM01RES, FAM01TIP, FAM01COB,FAM01STS,FAM01STP,CFcuenta, I02MOD, CCTcodigoAP,
							CCTcodigoDE, CCTcodigoFC, CCTcodigoCR, CCTcodigoRC, CCTcodigoRC, FAM01NPR, FAM01NPA,
							Aid, Mcodigo, FAM01TIF, FAPDES
						from FAM001
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
 
					<cfinvoke
					 component="sif.Componentes.pListas"
					 method="pLista"
					 returnvariable="pListaRet">
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="apertura_cajas.cfm"/>
					<cfinvokeargument name="keys" value="FAM01COD"/>
					<cfinvokeargument name="PageIndex" value="1"/>					
					<cfinvokeargument name="showemptylistmsg" value="true"/>
					<cfinvokeargument name="desplegar" value="FAM01CODD,FAM01DES,Oficodigo"/>
					<cfinvokeargument name="etiquetas" value=" C&oacute;digo, Descripci&oacute;n, Oficina"/>
					<cfinvokeargument name="align" value="left, left, center"/>
					<cfinvokeargument name="formatos" value="V, V, S"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>					
					<cfinvokeargument name="columnas" value="fa.Ocodigo, o.Oficodigo
															, FAM01COD, FAM01CODD, FAM09MAQ 
															, FAM01DES
															, FAM01RES, FAM01TIP, FAM01COB,FAM01STS,FAM01STP,fa.CFcuenta
															, I02MOD, CCTcodigoAP,CCTcodigoDE, CCTcodigoFC, CCTcodigoCR
															, CCTcodigoRC, CCTcodigoRC, FAM01NPR, FAM01NPA,
															Aid, Mcodigo, FAM01TIF, FAPDES"/>					
					<cfinvokeargument name="filtrar_por" value="FAM01CODD,FAM01DES,Oficodigo"/>					
					<cfinvokeargument name="tabla" value="FAM001 fa
															left outer join Oficinas o
																on o.Ocodigo=fa.Ocodigo
																	and o.Ecodigo=fa.Ecodigo"/>					
					<cfinvokeargument name="filtro" value="fa.Ecodigo=#session.Ecodigo#"/>								
				 </cfinvoke>				 
		</td>
		<td width="30%" valign="top">
			<cfinclude template="apertura_cajas-form.cfm">
		</td>
	</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>
