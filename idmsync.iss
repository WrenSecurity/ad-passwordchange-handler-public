;
; DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
;
; Copyright (c) 2012 ForgeRock Inc. All rights reserved.
;
; The contents of this file are subject to the terms
; of the Common Development and Distribution License
; (the License). You may not use this file except in
; compliance with the License.
;
; You can obtain a copy of the License at
; http://forgerock.org/license/CDDLv1.0.html
; See the License for the specific language governing
; permission and limitations under the License.
;
; When distributing Covered Code, include this CDDL
; Header Notice in each file and include the License file
; at http://forgerock.org/license/CDDLv1.0.html
; If applicable, add the following below the CDDL Header,
; with the fields enclosed by brackets [] replaced by
; your own identifying information:
; "Portions Copyrighted [2012] [Forgerock Inc]"
;

#define IDMAppName "OpenIDM Password Sync"
#define IDMAppVersion "2.1.0"
#define IDMAppPublisher "ForgeRock Inc"
#define IDMAppURL "http://www.forgerock.com/"

[Setup]
AppId={{7D1925B1-E009-4417-ABB4-CD427ABA49F7}
AppName={#IDMAppName}
AppVersion={#IDMAppVersion}
AppVerName={#IDMAppName}
AppPublisher={#IDMAppPublisher}
AppPublisherURL={#IDMAppURL}
AppSupportURL={#IDMAppURL}
AppUpdatesURL={#IDMAppURL}
DefaultDirName={pf}\{#IDMAppName}
DefaultGroupName={#IDMAppName}
DisableProgramGroupPage=yes
LicenseFile=license.txt
OutputDir=.\out\
OutputBaseFilename=idm-setup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64
AlwaysRestart=yes
UninstallRestartComputer=yes
Uninstallable=yes
MinVersion=0,6.0.6001

[Messages]
WinVersionTooLowError=This program requires Windows 2008 or later.

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: ".\out\64\idmsync.dll"; DestDir: "{sys}"; DestName: "idmsync.dll"; Flags: replacesameversion restartreplace uninsrestartdelete; Check: Is64BitInstallMode
Source: ".\out\64\idmsync.exe"; DestDir: "{app}"; DestName: "idmsync.exe"; Flags: replacesameversion restartreplace uninsrestartdelete; Check: Is64BitInstallMode
Source: ".\out\32\idmsync.dll"; DestDir: "{sys}"; DestName: "idmsync.dll"; Flags: replacesameversion restartreplace uninsrestartdelete; Check: not Is64BitInstallMode
Source: ".\out\32\idmsync.exe"; DestDir: "{app}"; DestName: "idmsync.exe"; Flags: replacesameversion restartreplace uninsrestartdelete; Check: not Is64BitInstallMode
Source: ".\license.txt"; DestDir: "{app}"; DestName: "license.txt";

[Run]
Filename: "{app}\idmsync.exe"; Parameters: "--install"; StatusMsg: "Installing OpenIDM Service..."

[UninstallRun]
Filename: "{app}\idmsync.exe"; Parameters: "--remove"; StatusMsg: "Removing OpenIDM Service..."

[Registry]
Root: HKLM; Subkey: "Software\ForgeRock"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "idmURL"; ValueData: "{code:GetOption|idmURL}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "passwordAttr"; ValueData: "{code:GetOption|passwordAttr}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "authType"; ValueData: "{code:GetOption|authType}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "authToken0"; ValueData: "{code:GetOption|authToken0}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "authToken1"; ValueData: "{code:GetOption|authToken1}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "dataPath"; ValueData: "{code:GetXmlDir}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "pollEach"; ValueData: "{code:GetOption|pollEach}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "logPath"; ValueData: "{code:GetLogDir}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "logLevel"; ValueData: "{code:GetOption|logLevel}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "certFile"; ValueData: "{code:GetOption|certFile}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "certPassword"; ValueData: "{code:GetOption|certPassword}"
Root: HKLM; Subkey: "Software\ForgeRock\OpenIDM\PasswordSync"; ValueType: string; ValueName: "keyAlias"; ValueData: "{code:GetOption|keyAlias}"
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Lsa"; ValueType: multisz; ValueName: "Notification Packages"; ValueData: "{olddata}{break}idmsync"; Check: NeedsAddDll('idmsync')

[Dirs]
Name: {code:GetXmlDir}; Flags: uninsneveruninstall
Name: {code:GetLogDir}; Flags: uninsneveruninstall

[Code]
var
  InputPageA: TInputQueryWizardPage;
  LogType: TComboBox;
  LogTypeLabel: TNewStaticText;
  AuthType: TComboBox;
  AuthTypeLabel: TNewStaticText;
  InputPageB: TInputQueryWizardPage;
  DataDirPage: TInputDirWizardPage;
  LogDirPage: TInputDirWizardPage;
  CertFilePage: TInputFileWizardPage;
  CertPassLabelE: TNewStaticText;
  CertPassE: TPasswordEdit;
  CertAliasLabelE: TNewStaticText;
  CertAlias: TEdit;
  PollLabel: TNewStaticText;
  Poll: TEdit;
  CertFilePageA: TInputFileWizardPage;
  CertPassLabelA: TNewStaticText;
  CertPassA: TPasswordEdit;
  value: String;
  value0: String;
  value1: String;

procedure InitializeWizard;
begin
  InputPageA := CreateInputQueryPage(wpLicense,
    'OpenIDM Information', 'Connection',
    'Please specify OpenIDM server deployment URL and request template information, then click Next.');
  InputPageA.Add('OpenIDM URL:', False);
  InputPageA.Add('OpenIDM User Password attribute:', False);

  InputPageB := CreateInputQueryPage(InputPageA.ID,
    'OpenIDM Information', 'Authentication',
    'Please specify OpenIDM authentication parameters, then click Next.');
  InputPageB.Add('User name:', False);
  InputPageB.Add('Password:', True);
  AuthTypeLabel := TNewStaticText.Create(InputPageB);
  AuthTypeLabel.Top := 130;
  AuthTypeLabel.Caption := 'Select authentication type:';
  AuthTypeLabel.AutoSize := True;
  AuthTypeLabel.Parent := InputPageB.Surface;
  AuthType := TComboBox.Create(InputPageB);
  AuthType.Top := 145; 
  AuthType.Width := InputPageB.SurfaceWidth;
  AuthType.Parent := InputPageB.Surface;
  AuthType.Style := csDropDownList;
  AuthType.Items.Add('None');
  AuthType.Items.Add('HTTP Basic');
  AuthType.Items.Add('OpenIDM Header');
  AuthType.Items.Add('Certificate');
  AuthType.ItemIndex := 0;

  CertFilePageA := CreateInputFilePage(InputPageB.ID,
    'OpenIDM Information', 'Certificate authentication',
    'Select Certificate file (PKCS12 format) which will be used for authentication, then click Next.');
  CertFilePageA.Add('','Certificate files|*.pfx|All files|*.*','.pfx');
  CertPassLabelA := TNewStaticText.Create(CertFilePageA);
  CertPassLabelA.Top := 70;
  CertPassLabelA.Caption := 'Password to open certificate file:';
  CertPassLabelA.AutoSize := True;
  CertPassLabelA.Parent := CertFilePageA.Surface;
  CertPassA := TPasswordEdit.Create(CertFilePageA);
  CertPassA.Top := 85;
  CertPassA.Width := CertFilePageA.SurfaceWidth;
  CertPassA.Parent := CertFilePageA.Surface;

  CertFilePage := CreateInputFilePage(CertFilePageA.ID,
    'Password Encryption', 'Data encryption',
    'Select Certificate file (PKCS12 format) which will be used for data encryption, then click Next.');
  CertFilePage.Add('','Certificate files|*.pfx|All files|*.*','.pfx');
  CertAliasLabelE := TNewStaticText.Create(CertFilePage);
  CertAliasLabelE.Top := 70;
  CertAliasLabelE.Caption := 'Private Key alias (for decryption):';
  CertAliasLabelE.AutoSize := True;
  CertAliasLabelE.Parent := CertFilePage.Surface;
  CertAlias := TEdit.Create(CertFilePage);
  CertAlias.Top := 85;
  CertAlias.Width := CertFilePage.SurfaceWidth;
  CertAlias.Parent := CertFilePage.Surface;
  CertPassLabelE := TNewStaticText.Create(CertFilePage);
  CertPassLabelE.Top := 115;
  CertPassLabelE.Caption := 'Password to open certificate file:';
  CertPassLabelE.AutoSize := True;
  CertPassLabelE.Parent := CertFilePage.Surface;
  CertPassE := TPasswordEdit.Create(CertFilePage);
  CertPassE.Top := 130;
  CertPassE.Width := CertFilePage.SurfaceWidth;
  CertPassE.Parent := CertFilePage.Surface;
    
  DataDirPage := CreateInputDirPage(CertFilePage.ID,
    'Data Storage', 'Where should Service output data files be stored?',
    'Select the folder in which Service will store its output data files, then click Next.',
    False, 'New Folder');
  PollLabel := TNewStaticText.Create(DataDirPage);
  PollLabel.Top := 70;
  PollLabel.Caption := 'Directory poll interval (in seconds). Empty or zero value will disable polling module:';
  PollLabel.AutoSize := True;
  PollLabel.Parent := DataDirPage.Surface;
  Poll := TEdit.Create(DataDirPage);
  Poll.Top := 85;
  Poll.Width := DataDirPage.SurfaceWidth;
  Poll.Parent := DataDirPage.Surface;
  DataDirPage.Add('');

  LogDirPage := CreateInputDirPage(DataDirPage.ID,
    'Log Storage', 'Where should Service log files be stored?',
    'Select the folder in which Service will store its log files, then click Next.',
    False, 'New Folder');
  LogTypeLabel := TNewStaticText.Create(LogDirPage);
  LogTypeLabel.Top := 70;
  LogTypeLabel.Caption := 'Select logging level:';
  LogTypeLabel.AutoSize := True;
  LogTypeLabel.Parent := LogDirPage.Surface;
  LogType := TComboBox.Create(LogDirPage);
  LogType.Top := 85; 
  LogType.Width := LogDirPage.SurfaceWidth;
  LogType.Parent := LogDirPage.Surface;
  LogType.Style := csDropDownList;
  LogType.Items.Add('error');
  LogType.Items.Add('info');
  LogType.Items.Add('warning');
  LogType.Items.Add('fatal');
  LogType.Items.Add('debug');
  LogType.ItemIndex := 0;
  LogDirPage.Add('');
  
  value := '';
  if not RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'idmURL', value) or (value = '') then begin
			InputPageA.Values[0] := 'https://localhost:8444/openidm/managed/user?_action=patch&_queryId=for-userName&uid=${samaccountname}';
	end else InputPageA.Values[0] := value;
  value := '';
  if not RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'passwordAttr', value) or (value = '') then begin
			InputPageA.Values[1] := 'adPassword';
	end else InputPageA.Values[1] := value;
  value := '';

  RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'authType', value);
  if (value = 'basic') then begin
      RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'authToken0', value0);
      RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'authToken1', value1);
      InputPageB.Values[0] := value0;
      InputPageB.Values[1] := value1;
      AuthType.ItemIndex := 1;
  end else if (value = 'idm') then begin
      RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'authToken0', value0);
      RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'authToken1', value1);
      InputPageB.Values[0] := value0;
      InputPageB.Values[1] := value1;
      AuthType.ItemIndex := 2;
  end else if (value = 'cert') then begin
      RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'authToken0', value0);
      RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'authToken1', value1);
      InputPageB.Values[0] := '';
      InputPageB.Values[1] := '';
      AuthType.ItemIndex := 3;
      CertFilePageA.Values[0] := value0;
      CertPassA.Text := value1;
  end else begin
      InputPageB.Values[0] := '';
      InputPageB.Values[1] := '';
      AuthType.ItemIndex := 0;
      CertFilePageA.Values[0] := '';
      CertPassA.Text := '';
  end
  value0 := '';
  value1 := '';
  value := '';

  if not RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'certFile', value) or (value = '') then begin
			CertFilePage.Values[0] := '';
	end else CertFilePage.Values[0] := value;
  value := '';
  if not RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'certPassword', value) or (value = '') then begin
			CertPassE.Text := '';
	end else CertPassE.Text := value;
  value := '';
  if not RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'keyAlias', value) or (value = '') then begin
			CertAlias.Text := 'openidm-cert';
	end else CertAlias.Text := value;
  value := '';
  
  if not RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'dataPath', value) or (value = '') then begin
			DataDirPage.Values[0] := '';
	end else DataDirPage.Values[0] := value;
  value := '';
  if not RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'pollEach', value) or (value = '') then begin
			Poll.Text := '';
	end else Poll.Text := value;
  value := '';

  if not RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'logPath', value) then begin
			LogDirPage.Values[0] := '';
	end else LogDirPage.Values[0] := value;
  value := '';
  RegQueryStringValue(HKLM, 'Software\ForgeRock\OpenIDM\PasswordSync', 'logLevel', value);
  if (value = 'error') then begin
      LogType.ItemIndex := 0;
  end else if (value = 'info') then begin
      LogType.ItemIndex := 1;
  end else if (value = 'warning') then begin
      LogType.ItemIndex := 2;
  end else if (value = 'fatal') then begin
      LogType.ItemIndex := 3;
  end else if (value = 'debug') then begin
      LogType.ItemIndex := 4;
  end else begin
      LogType.ItemIndex := 0;
  end
  value := '';

end;

function GetOption(Param: String): String;
begin
  if Param = 'idmURL' then
    Result := InputPageA.Values[0]
  else if Param = 'passwordAttr' then
    Result := InputPageA.Values[1]
  else if Param = 'authType' then
   if (AuthType.ItemIndex = 1) then begin
      Result := 'basic'
   end else if (AuthType.ItemIndex = 2) then begin
      Result := 'idm'
   end else if (AuthType.ItemIndex = 3) then begin
      Result := 'cert'
   end else begin
      Result := 'none'
   end
  else if Param = 'authToken0' then
   if (AuthType.ItemIndex = 1) or (AuthType.ItemIndex = 2) then begin
      Result := InputPageB.Values[0]
   end else if (AuthType.ItemIndex = 3) then begin
      Result := CertFilePageA.Values[0]
   end else begin
      Result := ''
   end
  else if Param = 'authToken1' then
   if (AuthType.ItemIndex = 1) or (AuthType.ItemIndex = 2) then begin
      Result := InputPageB.Values[1]
   end else if (AuthType.ItemIndex = 3) then begin
      Result := CertPassA.Text
   end else begin
      Result := ''
   end
  else if Param = 'pollEach' then
    Result := Poll.Text
  else if Param = 'logLevel' then
   if (LogType.ItemIndex = 1) then begin
      Result := 'error';
   end else if (LogType.ItemIndex = 2) then begin
      Result := 'warning'
   end else if (LogType.ItemIndex = 3) then begin
      Result := 'fatal'
   end else if (LogType.ItemIndex = 4) then begin
      Result := 'debug'
   end else begin
      Result := 'error'
   end
  else if Param = 'certFile' then
    Result := CertFilePage.Values[0]
  else if Param = 'certPassword' then
    Result := CertPassE.Text
  else if Param = 'keyAlias' then
    Result := CertAlias.Text
end;

function GetXmlDir(Param: String): String;
begin
  Result := DataDirPage.Values[0];
end;

function GetLogDir(Param: String): String;
begin
  Result := LogDirPage.Values[0];
end;

function NeedsAddDll(Param: string): boolean;
var
  OrigVal: string;
begin
  if not RegQueryMultiStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Lsa', 'Notification Packages', OrigVal)
  then begin
    Result := True;
    exit;
  end;
  Result := Pos(Param, OrigVal) = 0;
end;

function fixDllEntry(): Boolean;
var
  OrigVal: string;
begin
  if RegQueryMultiStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Lsa', 'Notification Packages', OrigVal)
  then begin
   if StringChangeEx(OrigVal, 'idmsync'+#0, '', True) > 0 then begin
     if not RegWriteMultiStringValue(HKEY_LOCAL_MACHINE,'SYSTEM\CurrentControlSet\Control\Lsa', 'Notification Packages', OrigVal) then begin
       MsgBox('Error cleaning up "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Notification Packages" registry entry. You must remove "idmsync" value manualy.', mbError, MB_OK);
     end;
   end else begin
     MsgBox('Error locating "idmsync" in "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Notification Packages" registry entry', mbError, MB_OK);
   end; 
  end;
   Result := True;
end;

function fixPath(KeyName: String): Boolean;
var
  OrigVal: string;
begin
  if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\ForgeRock\OpenIDM\PasswordSync', KeyName, OrigVal)
  then begin
   if StringChangeEx(OrigVal, '\', '\\', True) > 0 then begin
     RegWriteStringValue(HKEY_LOCAL_MACHINE, 'Software\ForgeRock\OpenIDM\PasswordSync', KeyName, OrigVal);
   end; 
  end;
   Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then begin
     fixPath('certFile');
     fixPath('logPath');
     fixPath('dataPath');
     if AuthType.ItemIndex = 3 then begin
        fixPath('authToken0');
     end;
  end;
end; 

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then begin
    if not NeedsAddDll('idmsync') then begin
       fixDllEntry(); 
    end;
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin          
  Result := (PageID = CertFilePageA.ID) and (AuthType.ItemIndex < 3);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = InputPageA.ID then begin
    if InputPageA.Values[0] = '' then begin
      MsgBox('You must enter valid OpenIDM URL.', mbError, MB_OK);
      Result := False;
    end else begin
      Result := True;
    end;
    if InputPageA.Values[1] = '' then begin
      MsgBox('You must enter valid OpenIDM User Password attribute value.', mbError, MB_OK);
      Result := False;
    end else begin
      Result := True;
    end;
  end else if CurPageID = InputPageB.ID then begin
    if (AuthType.ItemIndex = 1) or (AuthType.ItemIndex = 2) then begin
       if InputPageB.Values[0] = '' then begin
         MsgBox('You must enter user name.', mbError, MB_OK);
         Result := False;
       end else begin
         Result := True;
       end;
    end else begin
       Result := True;
    end;
  end else if CurPageID = CertFilePageA.ID then begin
    if CertFilePageA.Values[0] = '' then begin
      MsgBox('You must enter Certificate file name.', mbError, MB_OK);
      Result := False;
    end else begin
      Result := True;
    end;
  end else if CurPageID = CertFilePage.ID then begin
    if CertFilePage.Values[0] = '' then begin
      MsgBox('You must enter Certificate file name.', mbError, MB_OK);
      Result := False;
    end else if CertAlias.Text = '' then begin
      MsgBox('You must enter Private Key alias value.', mbError, MB_OK);
      Result := False;
    end else begin
      Result := True;
    end;
  end else if CurPageID = DataDirPage.ID then begin
    if DataDirPage.Values[0] = '' then begin
      MsgBox('You must enter Service Data storage directory name.', mbError, MB_OK);
      Result := False;
    end else begin
      Result := True;
    end;
  end else if CurPageID = LogDirPage.ID then begin
    if LogDirPage.Values[0] = '' then begin
      MsgBox('You must enter Service Log storage directory name.', mbError, MB_OK);
      Result := False;
    end else begin
      Result := True;
    end;
  end else
    Result := True;
end;
