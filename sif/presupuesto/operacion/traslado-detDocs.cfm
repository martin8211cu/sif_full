<table>
	<tr>
	  <td colspan="2" class="tituloAlterno">Documentación relacionada al Traslado de Presupuesto</td>
	</tr>
	<tr>
	  <td width="10%" align="right" nowrap="nowrap">
	  	<strong>Nuevo Documento:</strong>&nbsp;
	  </td>
	  <td width="45%" nowrap="nowrap">
		<input type="file" name="CPDDdoc" onchange="sbFileChange(this);" size="70"/>
		<input type="input" name="CPDDarchivo1" id="CPDDarchivo1" size="50" />
		<input type="input" name="CPDDarchivo2" id="CPDDarchivo2" size="5" />
		<script language="javascript">
			function sbFileChange(t)
			{
				var LvarFile = t.value;
				var LvarSlash = 0;
				var n=LvarFile.length;
				var LvarPto = n;
				LvarFile = LvarFile.replace(/\\/g,'/');
				for(var i=0; i < n; i++)
				{
					if (LvarFile.substr(i,1) == "/")
					{
						LvarSlash = i+1;
					}
					else if (LvarFile.substr(i,1) == ".")
					{
						LvarPto = i;
					}
				}
				document.getElementById("CPDDarchivo1").value = LvarFile.substring(LvarSlash,LvarPto);
				document.getElementById("CPDDarchivo2").value = LvarFile.substring(LvarPto,n);
			}
		</script>
	  </td>
	</tr>
	<tr>
	  <td width="10%" align="right">
	  	<strong>Descripcion:</strong>&nbsp;
	  </td>
	  <td width="45%" nowrap="nowrap">
		<input type="input" name="CPDDdescripcion" size="144" maxlength="255"/>
	  </td>
	</tr>
	<tr>
	  <td width="10%" align="right">&nbsp;
		
	  </td>
	  <td width="45%" nowrap="nowrap">
		<input type="submit" name="btnDocAdd" value="Agregar"  onclick="return sbDocAgregar();"/>
		<script language="javascript">
			function sbDocAgregar()
			{
				if (document.getElementById("CPDDdoc").value == "")
				{
					alert("Debe indicar un Archivo");
					return false
				}
				if (document.getElementById("CPDDarchivo1").value == "")
				{
					alert("Nombre de Archivo no debe quedar en blanco");
					return false
				}
				if (document.getElementById("CPDDdescripcion").value == "")
				{
					alert("Descripcion de Archivo no debe quedar en blanco");
					return false
				}
				inhabilitarValidacion();
				return true;
			}

			function sbOP(op,id)
			{
				document.form1.nosubmit=true;
				
				<cfoutput>
				if (op == 2)
				{
					document.getElementById("ifrDoc").src = 'traslado-sql.cfm?DocOP='+op+'&id='+id+'&CPDEid='+#form.CPDEid#;
				}
				else
				{
				<cfif LvarTrasladoExterno>
					location.href = 'traslado-sql.cfm?TE&DocOP='+op+'&id='+id+'&CPDEid='+#form.CPDEid#;
				<cfelse>
					location.href = 'traslado-sql.cfm?DocOP='+op+'&id='+id+'&CPDEid='+#form.CPDEid#;
				</cfif>
				}
				</cfoutput>
			}
		</script>
		<iframe id="ifrDoc" style="display:none"></iframe>
	  </td>
	</tr>
	<tr>
	  <td colspan="2">
		<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsDocs#"/>
				<cfinvokeargument name="desplegar" value="OP, CPDDarchivo, CPDDdescripcion"/>
				<cfinvokeargument name="etiquetas" value="OP, Archivo, Descripcion"/>
				<cfinvokeargument name="formatos" value="S,S,S"/>
				<cfinvokeargument name="align" value="left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="keys" value="CPDDid">
				<cfinvokeargument name="MaxRows" value="20"/>
				<cfinvokeargument name="navegacion" value=""/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="PageIndex" value="5"/>		
		</cfinvoke>	
	  </td>
	</tr>
</table>