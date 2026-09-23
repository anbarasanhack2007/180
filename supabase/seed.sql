-- ============================================================================
-- CYBERSPRINT 180 — COMPLETE CURRICULUM SEED DATA
-- 6 Months, 24 Weeks, 180 Days, 6 Capstone Projects, Skills, Badges & Questions
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. MONTHS
-- ----------------------------------------------------------------------------

INSERT INTO public.months (id, month_number, title, description, objectives, days_start, days_end)
VALUES
('00000000-0000-0000-0000-000000000001', 1, 'Networking & Security Foundations', 'Core protocols, TCP/IP architecture, Wireshark packet dissection, subnetting, and threat modeling.', '["Understand OSI and TCP/IP 4-layer model", "Capture and analyze live packet streams in Wireshark", "Calculate IPv4 VLSM and subnet masks", "Understand common attacks (ARP spoofing, DNS cache poisoning, SYN floods)"]'::jsonb, 1, 30),
('00000000-0000-0000-0000-000000000002', 2, 'Linux Systems & Automation Scripting', 'Bash command line mastery, Linux kernel architecture, permissions, SUID privesc, and Python security tooling.', '["Master Linux command-line utilities and piping", "Inspect system processes, cron jobs, and auditd logs", "Automate network recon using Python socket and Scapy scripts", "Audit file permissions, capabilities, and GTFOBins vectors"]'::jsonb, 31, 60),
('00000000-0000-0000-0000-000000000003', 3, 'Web Application Penetration Testing', 'OWASP Top 10 vulnerabilities, HTTP protocol deep-dives, Burp Suite intercepting proxy, and exploit crafts.', '["Exploit SQL injection (in-band, error, time-based, blind)", "Craft reflected, stored, and DOM-based XSS payloads", "Bypass authentication, CSRF protections, and CORS misconfigs", "Audit REST APIs and GraphQL security flaws"]'::jsonb, 61, 90),
('00000000-0000-0000-0000-000000000004', 4, 'Defensive Security & SOC Operations', 'SIEM log telemetry, Splunk queries, Zeek/Suricata IDS, threat hunting, and incident response playbooks.', '["Deploy and query Splunk Enterprise / ELK Stack", "Analyze Windows Event IDs (4624, 4625, 4672, 7045) and Sysmon", "Detect C2 beacons and malware lateral movement", "Formulate incident response containment playbooks"]'::jsonb, 91, 120),
('00000000-0000-0000-0000-000000000005', 5, 'Offensive Security & Red Teaming', 'Active Directory enumeration, Kerberoasting, BloodHound analysis, Metasploit, and buffer overflows.', '["Enumerate Active Directory domains, users, and trusts", "Execute Kerberoasting, AS-REP roasting, and pass-the-hash attacks", "Navigate domain privilege escalation via BloodHound attack paths", "Grasp 32-bit x86 stack buffer overflows and shellcode basics"]'::jsonb, 121, 150),
('00000000-0000-0000-0000-000000000006', 6, 'Capstone Mastery & Career Readiness', 'Full capstone project deployments, technical interview sprints, resume polishing, and portfolio showcase.', '["Publish 6 production-grade GitHub capstone repositories", "Master 150+ technical cybersecurity interview questions", "Generate ATS-compliant cybersecurity CV", "Pass final 100-question comprehensive board exam"]'::jsonb, 151, 180)
ON CONFLICT (month_number) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    objectives = EXCLUDED.objectives;

-- ----------------------------------------------------------------------------
-- 2. WEEKS (Weeks 1 to 24)
-- ----------------------------------------------------------------------------

INSERT INTO public.weeks (id, month_id, week_number, title, objective)
VALUES
('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', 1, 'Cyber Fundamentals & Security Models', 'Understand CIA Triad, Defense-in-Depth, threat actors, and attack surfaces.'),
('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', 2, 'TCP/IP Protocols & Packet Dissection', 'Capture and dissect TCP, UDP, ICMP, DNS, and HTTP traffic in Wireshark.'),
('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000001', 3, 'Network Architecture & Subnetting', 'Calculate IPv4 subnets, configure VLANs, routing protocols, and firewalls.'),
('10000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000001', 4, 'Network Attacks & Defense Foundations', 'Analyze ARP spoofing, DNS poisoning, and configure Snort IDS rules.'),
('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000002', 5, 'Linux Shell & System Navigation', 'Master file management, piping, grep, sed, awk, and vim in Linux.'),
('10000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-000000000002', 6, 'Linux Permissions & Security Auditing', 'Audit SUID binaries, sudo permissions, cron tasks, and kernel security.'),
('10000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000002', 7, 'Python for Cyber Operators: Sockets', 'Write raw socket port scanners and banner grabbers in Python 3.'),
('10000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000002', 8, 'Scapy Automation & Packet Crafting', 'Build custom packet sniffers and ARP spoof detectors in Scapy.'),
('10000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000003', 9, 'Web Architecture & HTTP Fundamentals', 'Inspect headers, cookies, sessions, and configure Burp Suite proxy.'),
('10000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000003', 10, 'SQL Injection Exploitation & Defense', 'Practice UNION, error-based, and blind SQLi on PortSwigger labs.'),
('10000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000003', 11, 'Cross-Site Scripting (XSS) & CSRF', 'Exploit reflected, stored, and DOM XSS; bypass anti-CSRF tokens.'),
('10000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000003', 12, 'SSRF, IDOR & Modern API Security', 'Exploit Server-Side Request Forgery and broken object-level authorization.'),
('10000000-0000-0000-0000-000000000013', '00000000-0000-0000-0000-000000000004', 13, 'SIEM Foundations & Splunk Deployment', 'Ingest server auth logs and query security events using Splunk SPL.'),
('10000000-0000-0000-0000-000000000014', '00000000-0000-0000-0000-000000000004', 14, 'Windows Event Logs & Sysmon Telemetry', 'Dissect event IDs 4624, 4625, 4672, and process creation in Sysmon.'),
('10000000-0000-0000-0000-000000000015', '00000000-0000-0000-0000-000000000004', 15, 'Network Security Monitoring (Zeek/Suricata)', 'Analyze live network connections, SSL certificates, and DNS logs.'),
('10000000-0000-0000-0000-000000000016', '00000000-0000-0000-0000-000000000004', 16, 'Incident Response & Threat Containment', 'Execute live triage, memory dump capture, and containment procedures.'),
('10000000-0000-0000-0000-000000000017', '00000000-0000-0000-0000-000000000005', 17, 'Active Directory Architecture & Enumeration', 'Query LDAP, BloodHound graphs, and enumerate domain shares and users.'),
('10000000-0000-0000-0000-000000000018', '00000000-0000-0000-0000-000000000005', 18, 'Kerberos Attacks & Lateral Movement', 'Execute Kerberoasting, AS-REP roasting, and pass-the-hash techniques.'),
('10000000-0000-0000-0000-000000000019', '00000000-0000-0000-0000-000000000005', 19, 'Metasploit & Post-Exploitation', 'Deploy meterpreter sessions, persistence mechanisms, and loot collection.'),
('10000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000005', 20, 'Binary Exploitation Fundamentals', 'Analyze x86 assembly, registers, stack frames, and control EIP.'),
('10000000-0000-0000-0000-000000000021', '00000000-0000-0000-0000-000000000006', 21, 'Capstone Project Sprint 1 & 2', 'Finalize Network Packet Sniffer and Multi-threaded Port Scanner repos.'),
('10000000-0000-0000-0000-000000000022', '00000000-0000-0000-0000-000000000006', 22, 'Capstone Project Sprint 3 & 4', 'Deploy Vulnerability Scanner and SOC Log Analysis SIEM pipelines.'),
('10000000-0000-0000-0000-000000000023', '00000000-0000-0000-0000-000000000006', 23, 'Interview Gauntlet & Technical Drills', 'Rehearse 150+ questions across networking, Linux, web, and SOC.'),
('10000000-0000-0000-0000-000000000024', '00000000-0000-0000-0000-000000000006', 24, 'Resume Polish, Final Exam & Graduation', 'Generate PDF CV, pass 100-question board exam, unlock champion rank.')
ON CONFLICT (week_number) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 3. REPRESENTATIVE SAMPLE OF 180 DAILY TASKS (Generating 180 entries)
-- ----------------------------------------------------------------------------

DO $$
DECLARE
    v_week_id UUID;
    v_day INT;
    v_week_num INT;
    v_title TEXT;
    v_obj TEXT;
    v_desc TEXT;
BEGIN
    FOR v_day IN 1..180 LOOP
        v_week_num := ((v_day - 1) / 7) + 1;
        IF v_week_num > 24 THEN v_week_num := 24; END IF;

        SELECT id INTO v_week_id FROM public.weeks WHERE week_number = v_week_num;

        -- Curated topics for specific milestone days
        IF v_day = 1 THEN
            v_title := 'Introduction to Cybersecurity, CIA Triad & Threat Profiles';
            v_obj := 'Grasp foundational confidentiality, integrity, and availability principles.';
            v_desc := 'Analyze modern threat actors, APT groups, zero-day vulnerabilities, and defense-in-depth strategies.';
        ELSIF v_day = 12 THEN
            v_title := 'Wireshark Packet Dissection & Filter Expressions';
            v_obj := 'Dissect live network packet streams and filter flags.';
            v_desc := 'Capture TCP 3-way handshakes, DNS queries, and diagnose transmission resets using Wireshark filters.';
        ELSIF v_day = 35 THEN
            v_title := 'Linux File Permissions, SUID & GTFOBins Auditing';
            v_obj := 'Audit special permissions and exploit SUID escalation vectors.';
            v_desc := 'Inspect chmod/chown, SUID bits (chmod 4755), and practice command escape sequences via GTFOBins.';
        ELSIF v_day = 68 THEN
            v_title := 'SQL Injection: UNION Attacks & Error-Based Payloads';
            v_obj := 'Exploit backend database queries via PortSwigger Academy.';
            v_desc := 'Determine column counts with ORDER BY and extract user credentials using UNION SELECT payloads.';
        ELSIF v_day = 95 THEN
            v_title := 'SIEM Log Ingestion & Splunk Search Processing Language (SPL)';
            v_obj := 'Query security events and detect brute force attempts.';
            v_desc := 'Write custom SPL search queries correlating failed logins followed by successful authentications.';
        ELSIF v_day = 125 THEN
            v_title := 'Active Directory Domain Architecture & BloodHound Graphing';
            v_obj := 'Map attack paths through domain groups and ACLs.';
            v_desc := 'Collect domain telemetry using SharpHound and identify shortest paths to Domain Admin.';
        ELSIF v_day = 180 THEN
            v_title := 'Final CyberSprint 180 Board Exam & Job-Readiness Review';
            v_obj := 'Validate complete 180-day cybersecurity mastery.';
            v_desc := 'Attempt the proctored 100-question board exam, export your verified PDF CV, and claim your certificate.';
        ELSE
            v_title := 'Sprint Day ' || v_day || ': Advanced Hands-On Security Drill';
            v_obj := 'Deepen technical capabilities in current phase objectives.';
            v_desc := 'Complete guided lab exercises, analyze relevant packet/log telemetry, and record field notes.';
        END IF;

        INSERT INTO public.daily_tasks (id, week_id, day_number, title, objective, description, estimated_minutes, xp_reward)
        VALUES (
            gen_random_uuid(),
            v_week_id,
            v_day,
            v_title,
            v_obj,
            v_desc,
            120,
            50
        )
        ON CONFLICT (day_number) DO NOTHING;
    END LOOP;
END $$;

-- ----------------------------------------------------------------------------
-- 4. CAPSTONE PROJECTS (6 Real-World Industry Projects)
-- ----------------------------------------------------------------------------

INSERT INTO public.projects (id, title, slug, description, objectives, architecture_summary, tech_stack, xp_reward)
VALUES
(
    '20000000-0000-0000-0000-000000000001',
    'Network Packet Sniffer & Protocol Analyzer',
    'packet-sniffer',
    'A high-performance raw socket network sniffer developed in Python that captures, parses, and reconstructs IPv4, TCP, UDP, ICMP, and DNS traffic in real-time.',
    '["Implement raw socket packet listeners", "Decode Ethernet, IP, TCP/UDP headers", "Detect SYN scan anomalies", "Export captured sessions to PCAP format"]'::jsonb,
    'CLI-driven packet engine capturing Layer 2/3 frames via AF_PACKET, decoding binary headers with struct unpack, and logging payload streams.',
    '["Python 3", "Scapy", "Raw Sockets", "Wireshark", "PCAP"]'::jsonb,
    500
),
(
    '20000000-0000-0000-0000-000000000002',
    'Automated Multi-Threaded Port Scanner & Service Fingerprinter',
    'port-scanner',
    'Fast concurrent TCP SYN & connect port scanner with banner grabbing, OS fingerprinting, and automated CVE correlation.',
    '["Multi-threaded socket pool for 1000+ ports/sec", "TCP SYN half-open scanning", "Service banner retrieval", "Output in JSON and Markdown"]'::jsonb,
    'Thread-pool architecture utilizing asynchronous I/O and low-level TCP handshakes to quickly map attack surfaces.',
    '["Python 3", "AsyncIO", "Nmap Engine", "Threading"]'::jsonb,
    500
),
(
    '20000000-0000-0000-0000-000000000003',
    'Web Application Vulnerability Scanner & Crawler',
    'web-vuln-scanner',
    'Automated vulnerability scanner that spiders web targets, checks HTTP security headers, identifies reflected inputs, and flags outdated libraries.',
    '["Recursive URL spidering and form detection", "Automated SQLi & XSS heuristic checks", "Security header verification (CSP, HSTS, X-Frame)", "HTML vulnerability report generation"]'::jsonb,
    'Modular crawler with custom payload injectors and DOM response analyzers that generates standardized remediation reports.',
    '["Python 3", "BeautifulSoup4", "Requests", "OWASP Top 10"]'::jsonb,
    600
),
(
    '20000000-0000-0000-0000-000000000004',
    'SOC Log Analysis & SIEM Detection Pipeline',
    'soc-siem-pipeline',
    'Enterprise log monitoring pipeline parsing Apache, Linux auth.log, and Windows Sysmon events to detect real-time intrusion patterns.',
    '["Ingest and normalize heterogeneous log formats", "Write SPL rules for brute-force and credential dumping", "Correlate IP reputation with AbuseIPDB", "Generate visual executive threat dashboards"]'::jsonb,
    'Log forwarder pushing telemetry into Elasticsearch / Splunk with alert triggers piped into webhook notifications.',
    '["Splunk", "ELK Stack", "Sysmon", "Zeek", "Suricata"]'::jsonb,
    700
),
(
    '20000000-0000-0000-0000-000000000005',
    'CyberShield AI: ML Threat Classifier Template',
    'cybershield-ai',
    'Python CLI project using Scikit-Learn to classify network flow anomalies and benign vs malicious URLs using NSL-KDD dataset.',
    '["Preprocess network flow datasets", "Train Random Forest & Logistic Regression classifiers", "Evaluate Precision, Recall, and ROC-AUC metrics", "Build CLI detection utility"]'::jsonb,
    'Scikit-learn pipeline with feature vectorization, hyperparameter tuning, and exportable joblib models for command-line inference.',
    '["Python 3", "Scikit-Learn", "Pandas", "NumPy", "NSL-KDD"]'::jsonb,
    750
),
(
    '20000000-0000-0000-0000-000000000006',
    'Active Directory Lab & Attack Graph Simulator',
    'ad-lab-simulator',
    'Automated PowerShell and Bash deployment scripts constructing a virtual Active Directory test lab with realistic vulnerabilities.',
    '["Spin up vulnerable Domain Controller and member workstations", "Configure misconfigured SPNs for Kerberoasting practice", "Implement vulnerable GPO permissions", "Document end-to-end compromise walk-through"]'::jsonb,
    'Infrastructure-as-Code scripts configuring virtual machines with Active Directory Domain Services, BloodHound audit accounts, and simulated enterprise user activity.',
    '["PowerShell", "Active Directory", "BloodHound", "VirtualBox", "Vagrant"]'::jsonb,
    1000
)
ON CONFLICT (slug) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 5. ACHIEVEMENTS & BADGES
-- ----------------------------------------------------------------------------

INSERT INTO public.achievements (id, title, description, badge_icon, xp_reward)
VALUES
(gen_random_uuid(), 'First Blood', 'Completed your very first CyberSprint daily mission.', 'bolt', 50),
(gen_random_uuid(), 'Terminal Initiate', 'Mastered fundamental Linux shell commands and file permissions.', 'terminal', 100),
(gen_random_uuid(), 'Packet Sniffer', 'Analyzed live TCP/IP streams and DNS handshakes in Wireshark.', 'wifi', 150),
(gen_random_uuid(), '7-Day Unbroken Streak', 'Maintained consistent cybersecurity practice for 7 days in a row.', 'local_fire_department', 250),
(gen_random_uuid(), 'Payload Crafter', 'Successfully completed all Web Security Academy SQLi & XSS labs.', 'bug_report', 300),
(gen_random_uuid(), 'SOC Tier-1 Certified', 'Analyzed real SIEM logs and detected a simulated brute-force campaign.', 'shield', 500),
(gen_random_uuid(), 'CyberSprint Champion', 'Completed all 180 days of the cybersecurity curriculum.', 'military_tech', 1000)
ON CONFLICT (title) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 6. INTERVIEW QUESTIONS (Technical Scrimmage)
-- ----------------------------------------------------------------------------

INSERT INTO public.interview_questions (id, category, question, answer, difficulty)
VALUES
(
    gen_random_uuid(),
    'Networking',
    'Explain the exact sequence of the TCP 3-way handshake and what happens during a SYN Flood attack.',
    '1. Client sends SYN (Synchronize) packet with Initial Sequence Number (ISN).\n2. Server responds with SYN-ACK, allocating kernel buffer resources and awaiting response.\n3. Client sends ACK to establish connection.\n\nIn a SYN Flood attack, the attacker spoofs IP addresses and floods the server with SYN packets without completing the ACK. The server leaves half-open connections until memory/backlog queue is exhausted (DoS). Mitigation: SYN cookies, rate limiting, and firewall timeouts.',
    'Medium'
),
(
    gen_random_uuid(),
    'Web Security',
    'What is the fundamental difference between Reflected, Stored, and DOM-based Cross-Site Scripting (XSS)?',
    '• Stored XSS: Malicious payload is permanently saved in the database/backend and served to every visiting user.\n• Reflected XSS: Payload is reflected off the web server immediately via search queries or error messages without being stored.\n• DOM XSS: Vulnerability exists entirely on the client-side JavaScript where untrusted input reaches an execution sink (e.g., eval, innerHTML, document.write) without ever touching server response HTML.',
    'Medium'
),
(
    gen_random_uuid(),
    'SOC / Incident Response',
    'How do you differentiate between a false positive and a true positive alert for an SSH brute-force detection in Splunk/SIEM?',
    '1. Check the source IP reputation (internal vs external public IP, known scanner or proxy).\n2. Analyze authentication logs: look for consecutive Failed Passwords followed by an Accepted Password (successful compromise).\n3. Check executed commands immediately following login (bash history, auditd logs, processes spawned).\n4. Check with internal system administrators if an automated service account, scheduled script, or Ansible deployment had misconfigured credentials.',
    'Hard'
),
(
    gen_random_uuid(),
    'Cryptography',
    'What is the purpose of Salt in password hashing, and why is SHA-256 alone insufficient for storing passwords?',
    'A salt is a cryptographically random unique string appended to passwords before hashing. It prevents Rainbow Table lookups and ensures identical passwords produce completely different hash digests.\n\nSHA-256 is designed to be fast in hardware (ASICs and GPUs can compute billions of SHA-256 hashes per second, making offline brute forcing trivial). Password hashing requires slow, memory-hard algorithms like Argon2id, bcrypt, or PBKDF2.',
    'Medium'
),
(
    gen_random_uuid(),
    'Linux Security',
    'What is an SUID bit in Linux, and how can an attacker leverage it for privilege escalation?',
    'SUID (Set User ID, permission 4000) causes an executable file to run with the permissions of the file owner (often root) rather than the executing user.\n\nIf a binary with SUID root allows arbitrary shell execution or command escapes (e.g. vim, find -exec, nmap, python), an unprivileged user can spawn a root shell. Reference: GTFOBins. Mitigation: Audit SUID files using `find / -perm -4000 -type f` and mount untrusted partitions with `nosuid`.',
    'Medium'
)
ON CONFLICT DO NOTHING;
