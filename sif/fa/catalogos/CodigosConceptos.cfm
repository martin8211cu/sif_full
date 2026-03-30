<cf_templateheader title="C&oacute;digos de Conceptos">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="C&oacute;digos de Conceptos">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			 	<tr>			  		
					<td>
						<cfinclude template="formCodigosConceptos.cfm">
					</td>
			 	</tr>
                <tr>
                  <td valign="top" width="30%" align="center">
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="tabla" 		value="FACodigosConceptos a
                                                                        inner join Conceptos c
                                                                          on a.Cid = c.Cid
                                                                          and a.Ecodigo = c.Ecodigo
                                                                        inner join CFuncional cf
                                                                          on a.CFid = cf.CFid 
                                                                          and a.Ecodigo = cf.Ecodigo
                                                                        inner join FCajas f
                                                                          on a.FCid = f.FCid
                                                                         and a.Ecodigo = f.Ecodigo
                                                                          "/>
							<cfinvokeargument name="columnas" 	value="convert(varchar,a.FCid) as FCid,f.FCdesc,f.FCcodigo,convert(varchar,a.Cid) as Cid, a.Ccodigo,c.Cdescripcion,convert(varchar,a.CFid) as CFid,a.CFcodigo,cf.CFdescripcion,FACCid"/>
							<cfinvokeargument name="desplegar" 	value="FCdesc,Cdescripcion,CFdescripcion"/>
							<cfinvokeargument name="etiquetas" 	value="Caja,Código Concepto,Centro Funcional"/>
							<cfinvokeargument name="formatos" 	value="S,S,S"/>
							<cfinvokeargument name="filtro" 	value="a.Ecodigo = #Session.Ecodigo#"/>
							<cfinvokeargument name="align" 		value="center,center,center,center"/>
							<cfinvokeargument name="ajustar" 	value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="keys" 		value="FACCid,FCid,Cid,CFid"/>
							<cfinvokeargument name="irA" 		value="CodigosConceptos.cfm"/>
						</cfinvoke>
					</td>
                </tr>
			</table>			
		<cf_web_portlet_end>
<cf_templatefooter>