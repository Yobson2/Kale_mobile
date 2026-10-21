import Image from "next/image";
import { SCREEN_HEIGHT, SCREEN_WIDTH } from "@/app/lib/screens";
import { cn } from "@/app/lib/utils";

interface PhoneFrameProps {
  src: string;
  alt: string;
  className?: string;
  priority?: boolean;
  sizes?: string;
}

/** A real app screenshot in a minimal device shell; the frame keeps the screen's ratio and never crops. */
export function PhoneFrame({
  src,
  alt,
  className,
  priority,
  sizes = "(min-width: 1024px) 320px, 70vw",
}: PhoneFrameProps) {
  return (
    <div
      className={cn(
        "bg-ink shadow-device relative rounded-[2.4rem] p-[0.55rem] ring-1 ring-white/10",
        className
      )}
    >
      <div
        className="bg-paper relative overflow-hidden rounded-[1.9rem]"
        style={{ aspectRatio: `${SCREEN_WIDTH} / ${SCREEN_HEIGHT}` }}
      >
        <Image
          src={src}
          alt={alt}
          fill
          sizes={sizes}
          priority={priority}
          className="object-cover object-top"
        />
      </div>
    </div>
  );
}
