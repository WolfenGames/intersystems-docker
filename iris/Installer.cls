Class iris.Installer 
{

XData setup [ XMLNamespace = INSTALLER ]
{
<Manifest>
  <SystemSetting 
    Name="Config.config.routines"
    Value="32"/>

  <SystemSetting 
    Name="Config.config.globals8kb"
    Value="512"/>

  <SystemSetting 
    Name="Config.config.locksiz"
    Value="117964800"/>

  <!--Setup names to be created here-->
  <ForEach 
      Index="TargetNameSpace"
      Values="NAMEHERE">
      <!--Code for each iteration of TargetNameSpace-->
      <Namespace Name="${TargetNameSpace}"
      Create="overwrite"
      Code="${TargetNameSpace}"
      Data="${TargetNameSpace}"
    >
      <Configuration>
        <Database Name="${TargetNameSpace}"
          Dir="/opt/database/${TargetNameSpace}"
          Create="overwrite"
          Resource="%DB_%DEFAULT"
          ClusterMountMode="0"
          Collation="5"
          Encrypted="0"
          ExpansionSize="1"
          InitialSize="1"
          MaximumSize="1024"
          MountAtStartup="0"
          MountRequired="0"
          StreamLocation=""
          PublicPermissions=""/>
      </Configuration>
    </Namespace>
  </ForEach>

</Manifest>
}

ClassMethod setup(
    ByRef pVars, 
    pLogLevel As %Integer = 3, 
    pInstaller As %Installer.Installer, 
    pLogger As %Installer.AbstractLogger
  ) As %Status [ CodeMode = objectgenerator, Internal ]
{
    do %code.WriteLine($char(9)_"set pVars(""CURRENTCLASS"")="""_%classname_"""")
    do %code.WriteLine($char(9)_"set pVars(""CURRENTNS"")="""_$namespace_"""")
  #; Let our XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}