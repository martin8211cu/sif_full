
<html>
<head>
	<title>Editar Proceso</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/util/css/todo.css" rel="stylesheet" type="text/css" />
</head>
<body>

	<cfquery datasource="minisif" name="data">
		select *
		from WfProcess
	</cfquery>
	
	<cfoutput>
		<form action="WfProcess-apply.jsp" onsubmit="return validar(this);" method="get">
			<table summary="Tabla de entrada">
			<tr><td colspan="2" class="subTitulo">
			Proceso
			</td></tr>

			
				
				
			
				
				
				<tr><td valign="top">Paquete
				</td><td>
				
					<input name="PackageId" type="text" value="#data.PackageId#" 
						maxlength="18"
						onfocus="this.select()" onblur="onblurnumeric()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Nombre
				</td><td>
				
					<input name="Name" type="text" value="#data.Name#" 
						maxlength="20"
						onfocus="this.select()" onblur="onblurvarchar()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Autor
				</td><td>

				
					<input name="Author" type="text" value="#data.Author#" 
						maxlength="30"
						onfocus="this.select()" onblur="onblurvarchar()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Versión
				</td><td>
				
					<input name="Version" type="text" value="#data.Version#" 
						maxlength="10"
						onfocus="this.select()" onblur="onblurvarchar()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Estado de publicación
				</td><td>
				
					<select name="Estado de publicación">
					
						<option value="UNDER_REVISION" ><cfif data.PublicationStatus is 'UNDER_REVISION'>selected</cfif> >
							En revisión
						</option>

					
						<option value="UNDER_TEST" ><cfif data.PublicationStatus is 'UNDER_TEST'>selected</cfif> >
							En pruebas
						</option>
					
						<option value="RELEASED" ><cfif data.PublicationStatus is 'RELEASED'>selected</cfif> >
							Publicado
						</option>
					
					</select>
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Creado
				</td><td>

				
					<input name="Created" type="text" value="#data.Created#" 
						maxlength=""
						onfocus="this.select()" onblur="onblurdatetime()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Descripción
				</td><td>
				
					<input name="Description" type="text" value="#data.Description#" 
						maxlength="255"
						onfocus="this.select()" onblur="onblurvarchar()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Prioridad
				</td><td>
				
					<select name="Prioridad">
					
						<option value="1" ><cfif data.Priority is '1'>selected</cfif> >
							Mínima
						</option>

					
						<option value="2" ><cfif data.Priority is '2'>selected</cfif> >
							Baja
						</option>
					
						<option value="3" ><cfif data.Priority is '3'>selected</cfif> >
							Normal
						</option>
					
						<option value="4" ><cfif data.Priority is '4'>selected</cfif> >
							Alta
						</option>
					
						<option value="5" ><cfif data.Priority is '5'>selected</cfif> >
							Máxima
						</option>

					
					</select>
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Límite
				</td><td>
				
					<input name="Limit" type="text" value="#data.Limit#" 
						maxlength="15"
						onfocus="this.select()" onblur="onblurdecimal()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Válido desde
				</td><td>
				
					<input name="ValidFrom" type="text" value="#data.ValidFrom#" 
						maxlength=""
						onfocus="this.select()" onblur="onblurdatetime()" />
				
				</td></tr>

				
			
				
				
				<tr><td valign="top">Válido hasta
				</td><td>
				
					<input name="ValidTo" type="text" value="#data.ValidTo#" 
						maxlength=""
						onfocus="this.select()" onblur="onblurdatetime()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Unidad de duración
				</td><td>
				
					<select name="Unidad de duración">
					
						<option value="Y" ><cfif data.DurationUnit is 'Y'>selected</cfif> >
							Año
						</option>

					
						<option value="M" ><cfif data.DurationUnit is 'M'>selected</cfif> >
							Mes
						</option>
					
						<option value="D" ><cfif data.DurationUnit is 'D'>selected</cfif> >
							Día
						</option>
					
						<option value="h" ><cfif data.DurationUnit is 'h'>selected</cfif> >
							Hora
						</option>
					
						<option value="m" ><cfif data.DurationUnit is 'm'>selected</cfif> >
							Minuto
						</option>

					
						<option value="s" ><cfif data.DurationUnit is 's'>selected</cfif> >
							Segundo
						</option>
					
					</select>
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Tiempo de espera estimado (s)
				</td><td>
				
					<input name="WaitingTimeEstimation" type="text" value="#data.WaitingTimeEstimation#" 
						maxlength="15"
						onfocus="this.select()" onblur="onblurdecimal()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Tiempo de trabajo estimado (s)
				</td><td>

				
					<input name="WorkingTimeEstimation" type="text" value="#data.WorkingTimeEstimation#" 
						maxlength="15"
						onfocus="this.select()" onblur="onblurdecimal()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Duración estimada (s)
				</td><td>
				
					<input name="DurationEstimation" type="text" value="#data.DurationEstimation#" 
						maxlength="15"
						onfocus="this.select()" onblur="onblurdecimal()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Ícono
				</td><td>
				
					<input name="Icon" type="text" value="#data.Icon#" 
						maxlength="10"
						onfocus="this.select()" onblur="onblurvarchar()" />
				
				</td></tr>

				
			
				
				
				<tr><td valign="top">Documentación
				</td><td>
				
					<input name="Documentation" type="text" value="#data.Documentation#" 
						maxlength=""
						onfocus="this.select()" onblur="onblurtext()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">No modificar
				</td><td>
				
					<input name="ReadOnly" type="text" value="#data.ReadOnly#" 
						maxlength=""
						onfocus="this.select()" onblur="onblurbit()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">Empresa
				</td><td>

				
					<input name="Ecodigo" type="text" value="#data.Ecodigo#" 
						maxlength=""
						onfocus="this.select()" onblur="onblurint()" />
				
				</td></tr>
				
			
				
				
				<tr><td valign="top">URL para ver detalle
				</td><td>
				
					<input name="DetailURL" type="text" value="#data.DetailURL#" 
						maxlength="255"
						onfocus="this.select()" onblur="onblurvarchar()" />
				
				</td></tr>
				
			
			<tr><td colspan="2" class="formButtons">
				<cf_botones>
			</td></tr>

			</table>
		</form>
	</cfoutput>
</body>
</html>
