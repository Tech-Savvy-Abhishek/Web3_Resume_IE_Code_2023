import React, { useEffect, useState } from "react";

function Resume({ account }) {
  const [mainAccount, setAccount] = useState(null);
  const [resume, setResumeData] = useState(null);

  useEffect(() => {
    let path = new URLSearchParams(window.location.search);
    if (path.get("account")) {
      setAccount(path.get("account"));
    } else if (account) {
      setAccount(account);
    }
  }, []);

  useEffect(() => {
    setResumeData({
      name: "John Doe",
      bio: "Hello, I'm John Doe. I am passionate about software development and always eager to learn new technologies.",
      study: [
        {
          institute_name: "ABC University",
          experience_type: "Education",
          title: "Bachelor of Science in Computer Science",
          start_date: "2010",
          end_date: "2014",
          description:
            "Studied various computer science topics including algorithms, data structures, and software engineering principles.",
        },
        {
          institute_name: "XYZ School",
          experience_type: "Education",
          title: "High School Diploma",
          start_date: "2006",
          end_date: "2010",
          description:
            "Completed high school with a focus on mathematics and science.",
        },
      ],
      experience: [
        {
          institute_name: "Tech Corp",
          experience_type: "Work Experience",
          title: "Senior Software Engineer",
          start_date: "2015",
          end_date: "Present",
          description:
            "Lead developer on multiple projects, specializing in full-stack web development using React and Node.js.",
        },
        {
          institute_name: "Software Innovations",
          experience_type: "Work Experience",
          title: "Software Developer",
          start_date: "2014",
          end_date: "2015",
          description:
            "Contributed to the development of various software applications, focusing on front-end development and user interface design.",
        },
      ],
    });
  }, [mainAccount]);

  return (
    <div>
      <h3>{resume?.name}</h3>
      <h6>{resume?.bio}</h6>
      <div style={{ marginTop: "2em" }}>
        <h5>Experience</h5>
        {resume?.experience.map((exp, index) => (
          <div key={index} style={{ marginTop: "1em" }}>
            <h5>{exp?.institute_name}</h5>
            <h5>{exp?.title}</h5>
            <h6>
              {exp?.start_date} - {exp?.end_date}
            </h6>
            <h6>{exp?.description}</h6>
          </div>
        ))}
      </div>
      <div style={{ marginTop: "2em" }}>
        <h5>Education</h5>
        {resume?.study.map((edu, index) => (
          <div key={index} style={{ marginTop: "1em" }}>
            <h5>{edu?.institute_name}</h5>
            <h5>{edu?.title}</h5>
            <h6>
              {edu?.start_date} - {edu?.end_date}
            </h6>
            <h6>{edu?.description}</h6>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Resume;
