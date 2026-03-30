<!--- Reporte de las 10 Entidades que más dinero han donado --->
<cf_sifHTML2Word listTitle="Los Mejores 10 Donadores">
		<table width="75%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td align="center" class="tituloAlterno">
				Los Mejores 10 Donadores
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>		  
		  <tr>
			<td>
				<cfinvoke 
				 component="sif.crm.Componentes.pListas"
				 method="pListaCRM"
				 returnvariable="pListaCRMRet">
					<cfinvokeargument name="tabla" value="
						CRMDDonacion dd, 
						CRMEDonacion ed, 
						CRMEntidad e
					"/>
					<cfinvokeargument name="columnas" value="
						convert(varchar,e.CRMEnombre + ' ' + e.CRMEapellido1 + ' ' + e.CRMEapellido2) as nombre, sum(CRMDmonto) as Suma
					"/>
					<cfinvokeargument name="desplegar" value="Nombre, Suma"/>
					<cfinvokeargument name="etiquetas" value="Entidad, Monto"/>
					<cfinvokeargument name="formatos" value="S, M"/>
					<cfinvokeargument name="filtro" value="
						dd.Ecodigo=#Session.Ecodigo#
						and dd.CEcodigo=#Session.CEcodigo#
						and dd.Ecodigo=ed.Ecodigo
						and dd.CEcodigo=ed.CEcodigo
						and dd.CRMEDid=ed.CRMEDid 	
						and ed.Ecodigo=e.Ecodigo
						and ed.CEcodigo=e.CEcodigo
						and dd.CRMEid=e.CRMEid 
						group by e.CRMEnombre, e.CRMEapellido1, e.CRMEapellido2
						order by Suma desc
					"/>
					<cfinvokeargument name="align" value="left, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value=""/>
					<cfinvokeargument name="showLink" value="true"/>
				</cfinvoke>	
			</td>
		  </tr>
		  <tr>
			<td align="center">
				--- Fin del Reporte ---
			</td>
		  </tr>
		  <tr>
			<td align="center">&nbsp;
			</td>
		  </tr>
		</table>
</cf_sifHTML2Word>